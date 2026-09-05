--[[--
- open the `stalwart-cli apply` .ndjson input (arg #1) and stalwart json schema (path in arg #2)
- recursively walk through all entries in the `stalwart-cli apply` plan and
	- note down definitions of and references to IDs, resolving them when possible, building a dependency graph
	- report any type errors
	- report any ID references without a corresponding definition
- if checking was successful, do a topological sort of the entries, ensuring definitions come before references
- write to the output file (path in arg #3)
--]]--

-- startup
local input, output_path, schema_path = ...
assert(input and output_path and schema_path, "missing args")

local json = require("dkjson")

-- friendly name for a given type
local function nameof(ty)
	if type(ty) == "string" then return ty
	elseif ty == nil then return "(nil type)"
	elseif ty.kind == "nullable" then return nameof(ty.of) .. "?"
	elseif ty.kind == "prim" then
		if ty.format then return ty.ty .. "<" .. ty.format .. ">"
		else return ty.ty end
	elseif ty.kind == "ref" then return "id<" .. nameof(ty.of) .. ">"
	elseif ty.kind == "list" then return "list<" .. nameof(ty.of) .. ">"
	elseif ty.kind == "set" then return "set<" .. nameof(ty.of) .. ">"
	elseif ty.kind == "map" then return "map<" .. nameof(ty.key) .. "," .. nameof(ty.val) .. ">"
	elseif ty.kind == "obj" or ty.kind == "var" then return ty.name
	elseif ty.kind == "enum" then return "enum<" .. ty.name .. ">" end
end

-- `type` specialized for json, since json.decode always sets metatables for tables so __jsontype is `array` or `object`
local function jty(val)
	if val == json.null then return "null" end
	local meta = getmetatable(val)
	return meta and meta.__jsontype or type(val)
end

local schema
do
	local fi = assert(io.open(schema_path), "failed to open schema file")
	schema = json.decode(fi:read("*a"))
	assert(io.close(fi), "failed to close schema file")
end

-- take the schema and convert it into a more understandable form
local behavior_map = {}
do
	local seen = {}

	local function nullable(of) return { kind = "nullable", of = of } end
	local function prim(ty, format) return { kind = "prim", ty = ty, format = format } end
	local function ref(of) return { kind = "ref", of = of } end
	local function list(of) return { kind = "list", of = of } end
	local function set(of) return { kind = "set", of = of } end
	local function map(key, val) return { kind = "map", key = key, val = val } end
	local function obj(name, fields) return { kind = "obj", name = name, fields = fields } end
	local function var(name, variants) return { kind = "var", name = name, variants = variants } end
	local function enum(name, variants) return { kind = "enum", name = name, variants = variants } end

	-- remove the x: prefix
	local function dex(name)
		if name:sub(1, 2) == "x:" then return name:sub(3)
		else return name end
	end

	local walk_schema

	local function walk_ty(ty)
		local out
		if ty.type == "boolean" or ty.type == "number" or ty.type == "string" then out = prim(ty.type, ty.format)
		elseif ty.type == "utcDateTime" then out = prim("datetime")
		elseif ty.type == "blobId" then out = prim("blob")
		elseif ty.type == "objectId" then out = ref(dex(ty.objectName))
		elseif ty.type == "object" then
			walk_schema(ty.objectName)
			out = dex(ty.objectName)
		elseif ty.type == "objectList" then
			walk_schema(ty.objectName)
			out = list(dex(ty.objectName))
		elseif ty.type == "map" then out = map(walk_ty(ty.keyClass), walk_ty(ty.valueClass))
		elseif ty.type == "set" then out = set(walk_ty(ty.class))
		elseif ty.type == "enum" then
			local variants = {}
			for _, info in ipairs(schema.enums[ty.enumName] or {}) do variants[info.name] = true end
			out = enum(dex(ty.enumName), variants)
		end
		if out and ty.nullable then return nullable(out) end
		return out
	end

	function walk_schema(name)
		if seen[name] then return behavior_map[dex(name)] end
		seen[name] = true

		local res

		local sch = schema.schemas[name]
		if sch.type == "single" then
			local props = schema.fields[sch.schemaName].properties
			local fields = {}
			for key, prop in pairs(props) do fields[key] = walk_ty(prop.type) end
			res = obj(dex(name), fields)
		elseif sch.type == "multiple" then
			local variants = {}
			for _, variant in ipairs(sch.variants) do
				local data
				if variant.schemaName then data = walk_schema(variant.schemaName) end
				if not data then data = obj(dex(variant.schemaName or variant.name), {}) end
				data.fields["@type"] = prim("string", "discriminant")
				variants[variant.name] = data
			end
			res = var(dex(name), variants)
		end

		behavior_map[dex(name)] = res
		return res
	end

	for name, info in pairs(schema.objects) do
		if info.type == "object" or info.type == "singleton" then walk_schema(name) end
	end
end

-- recursively search through all the objects and find references
local entries = {}
do
	local issues = 0

	local defined = {}
	local awaiting_definition = {}

	-- ~fancy~ error printer
	local ansi_red, ansi_grey, ansi_reset = "\27[0m\27[1;31m", "\27[0m\27[2;37m", "\27[0m"
	local function err(parent, msg, ...)
		print(("%s[error]%s %s %s// %s%s"):format(ansi_red, ansi_reset, msg:format(...), ansi_grey, parent, ansi_reset))
		issues = issues + 1
	end

	-- helper to check for id referent type mismatches
	local function check_id_ty_match(parent, id, got, expected)
		local expected_variant
		do
			local pos = expected:find("/")
			if pos then
				expected_variant = expected:sub(pos + 1)
				expected = expected:sub(1, pos - 1)
			end
		end

		if got.ty ~= expected or (expected_variant and got.variant ~= expected_variant) then
			err(
				parent,
				"id referent mismatch at `#%s`, expected `id<%s>`, got `id<%s>`",
				id,
				expected_variant and (expected .. "::" .. expected_variant) or expected,
				got.variant and (got.ty .. "::" .. got.variant) or got.ty
			)
		end
	end

	-- main recursive walker, doing typechecking and finding id dependencies
	local function recursearch(deps, ty, val, parent)
		local beh = ty
		while type(beh) == "string" do beh = behavior_map[beh] end
		if not beh then return end
		if beh.kind == "nullable" then
			if val == json.null then return end
			recursearch(deps, beh.of, val, parent)
		elseif beh.kind == "prim" then
			if beh.ty == "boolean" and type(val) ~= "boolean" then err(parent, "expected `%s` to be a boolean (got `%s`)", nameof(beh), jty(val))
			elseif beh.ty == "number" and type(val) ~= "number" then err(parent, "expected `%s` to be a number (got `%s`)", nameof(beh), jty(val))
			elseif (beh.ty == "string" or beh.ty == "datetime" or beh.ty == "blob") and type(val) ~= "string" then err(parent, "expected `%s` to be a string (got `%s`)", nameof(beh), jty(val)) end
		elseif beh.kind == "ref" then
			if jty(val) ~= "string" then return err(parent, "expected `%s` to be a string (got `%s`)", nameof(beh), jty(val)) end
			if val:sub(1, 1) == "#" then val = val:sub(2)
			else err(parent, "missing `#` prefix for `Id<%s>`: `%s`", beh.of, val) end

			if defined[val] then
				local def = defined[val]
				check_id_ty_match(parent, val, def, beh.of)
				table.insert(deps, def)
			else
				local new = { ty = beh.of, parent = parent, deps = deps }
				if awaiting_definition[val] then table.insert(awaiting_definition[val], new)
				else awaiting_definition[val] = { new } end
			end
		elseif beh.kind == "list" then
			if jty(val) ~= "object" then return err(parent, "expected `%s` to be an object mapping stringified integers to `%s` (got `%s`)", nameof(beh), beh.of, jty(val)) end
			for k, elem in pairs(val) do
				local success, nk = pcall(tonumber, k)
				if not success then err(parent, "`%s` key `%s` cannot convert to an integer", nameof(beh), k)
				elseif nk ~= math.floor(nk) then err(parent, "`%s` key `%s` is floating point", nameof(beh), k) end
				recursearch(deps, beh.of, elem, parent .. "[" .. k .. "]")
			end
		elseif beh.kind == "set" then
			if jty(val) ~= "object" then return err(parent, "expected `%s` to be an object mapping `%s` to `boolean` (got `%s`)", nameof(beh), nameof(beh.of), jty(val)) end
			for elem, v in pairs(val) do
				if type(v) ~= "boolean" then err(parent, "`%s` key `%s` does not have a boolean value", nameof(beh), tostring(v)) end
				recursearch(deps, beh.of, elem, parent .. "[`" .. elem .. "`]")
			end
		elseif beh.kind == "map" then
			if jty(val) ~= "object" then return err(parent, "expected `%s` to be an object mapping `%s` to `%s` (got `%s`)", nameof(beh), nameof(beh.key), nameof(beh.val), jty(val)) end
			for k, v in ipairs(val) do
				recursearch(deps, beh.key, k, parent .. "[key `" .. k .. "`]")
				recursearch(deps, beh.val, v, parent .. "[value for key `" .. k .. "`]")
			end
		elseif beh.kind == "obj" then
			if jty(val) ~= "object" then return err(parent, "expected object `%s` to be an object (got `%s`)", nameof(beh), jty(val)) end
			for k, v in pairs(val) do
				local vty = beh.fields[k]
				if not vty then return err(parent, "`%s` has unknown key `%s`", nameof(ty), k) end
				recursearch(deps, vty, v, parent .. "." .. k)
			end
		elseif beh.kind == "var" then
			if jty(val) ~= "object" then return err(parent, "expected multi-variant object `%s` to be an object (got `%s`)", nameof(beh), jty(val)) end
			local discriminant = val["@type"]
			if jty(discriminant) ~= "string" then return err(parent, "multi-variant object `%s` field `@type` must be a string (got `%s`)", nameof(beh), type(discriminant)) end
			local vty = beh.variants[discriminant]
			if not vty then return err(parent, "multi-variant type `%s` does not have variant `%s`", nameof(beh), discriminant) end
			recursearch(deps, vty, val, ("(%s as %s::%s)"):format(parent, beh.name, discriminant))
		elseif beh.kind == "enum" then
			if jty(val) ~= "string" then return err(parent, "expected enum `%s` to be a string (got `%s`)", nameof(beh), type(val)) end
			if not beh.variants[val] then return err(parent, "enum `%s` does not have variant `%s`", nameof(beh), val) end
		else error("internal: unknown beh kind: " .. beh.kind) end
	end

	print(input)
	print("--- input json above ---")

	-- go through each ndjson entry and start walking
	local ln = 0
	for line in input:gmatch("([^\n]+)") do
		ln = ln + 1
		local op = json.decode(line, 1, json.null)

		if jty(op) ~= "object" then return err("<line " .. ln .. ">", "expected line to be an object (got `%s`)", jty(op)) end
		if jty(op["@type"]) ~= "string" then return err("<line " .. ln .. ">", "expected `@type` field to be a string (got `%s`)", jty(op)) end
		if jty(op.object) ~= "string" then return err("<line " .. ln .. ">", "expected `object` field to be a string (got `%s`)", jty(op)) end
		if jty(op.value) ~= "object" then err("<operation: " .. op["@type"] .. " " .. op.object .. ">", "expected `value` field to be an object (got `%s`)", jty(op.value)) end

		local deps = {}
		if not behavior_map[op.object] then err("<operation: " .. op["@type"] .. " " .. op.object .. ">", "unknown object type `%s`", op.object)
		elseif op["@type"] == "update" then recursearch(deps, op.object, op.value, "<" .. op.object .. ">")
		else
			local match_fields
			if jty(op.matchOn) == "array" then
				match_fields = op.matchOn
				for _, field in ipairs(match_fields) do
					-- quick and dirty way to trigger the condition
					if type(field) ~= "string" then match_fields = nil end
				end
			end
			if op.matchOn ~= nil and op.matchOn ~= json.null and op.matchOn ~= "*" and not match_fields then err("<operation: " .. op["@type"] .. " " .. op.object .. ">", "expected `matchOn` field to be null, \"*\", or an array of strings (got `%s`)", jty(op.matchOn)) end

			for id, val in pairs(op.value) do
				local parent = "<" .. op.object .. " #" .. id .. ">"
				if match_fields then
					for _, field in ipairs(match_fields) do
						if val[field] == nil then err(parent, "match field `%s` missing", field) end
					end
				end
				if defined[id] then err(parent, "duplicate id `%s` (other definition at <%s #%s>)", id, defined[id].op.object, id) end
				local entry = {
					deps = deps,
					op = op,

					ty = op.object,
					variant = val["@type"],
				}
				defined[id] = entry
				if awaiting_definition[id] then
					for _, waiter in ipairs(awaiting_definition[id]) do
						check_id_ty_match(waiter.parent, id, entry, waiter.ty)
						table.insert(waiter.deps, entry)
					end
					awaiting_definition[id] = nil
				end
				recursearch(deps, op.object, val, parent)
			end
		end
		table.insert(entries, {
			deps = deps,
			op = op,
		})
	end

	-- report any ids that went undefined
	for id, waiters in pairs(awaiting_definition) do
		for _, waiter in ipairs(waiters) do
			err(waiter.parent, "undefined id: %s", id)
			issues = issues + 1
		end
	end

	if issues > 0 then error(issues .. " issues were detected!") end
end

-- topo-sort the results, so dependencies come before their dependents
local result = {}
do
	local seen = {}

	local function visit(entry)
		if seen[entry.op] then return end
		seen[entry.op] = true

		for _, dep in ipairs(entry.deps) do visit(dep) end

		table.insert(result, entry.op)
	end

	for _, entry in ipairs(entries) do visit(entry) end
end

-- collect every seen field and then sort them so we produce a consistent field ordering every time
-- lua `pairs` returns keys in an implementation-defined (read: nondeterministic) order, so we're explicitly sorting them
local field_order = {}
do
	local field_order_seen = {}

	local function recurse_fields(val)
		if type(val) ~= "table" then return end
		if #val > 0 then
			for _, v in pairs(val) do recurse_fields(v) end
		else
			for k, v in pairs(val) do
				if not field_order_seen[k] then
					field_order_seen[k] = true
					table.insert(field_order, k)
				end
				recurse_fields(v)
			end
		end
	end

	for _, op in ipairs(result) do recurse_fields(op) end

	table.sort(field_order)
end

-- write output to file
local output = assert(io.open(output_path, "w"), "failed to open output file")
for _, op in ipairs(result) do
	assert(output:write(json.encode(op, { keyorder = field_order })), "failed to write output")
	assert(output:write("\n"), "failed to write output")
end
assert(output:close(), "failed to close output file")
