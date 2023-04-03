local ldbus = require('ldbus')
local ffi = require('ffi')

local function nspawn_to_dns(state, req)
  local system_bus = ldbus.bus.get('system')
  local qry = req:current()

  local name = string.gmatch(kres.dname2str(qry.sname), "[^\\.]+")()
  name = string.gsub(name, "-", "_2d")
  local dns_query_msg = ldbus.message.new_method_call(
    'org.freedesktop.machine1',
    '/org/freedesktop/machine1/machine/' .. name,
    'org.freedesktop.machine1.Machine',
    'GetAddresses'
  )

  local top_iter = ldbus.message.iter.new()

  dns_query_msg:iter_init_append(top_iter)
  local reply = system_bus:send_with_reply_and_block(dns_query_msg)
  if reply == nil then return state end

  local answer = req:ensure_answer()
  if answer == nil then return nil end
  ffi.C.kr_pkt_make_auth_header(answer)

  answer:rcode(kres.rcode.NOERROR)
  local type = qry.stype
  if not (type == kres.type.A or type == kres.type.AAAA) then
    return kres.DONE
  end

  reply:iter_init(top_iter)

  assert(top_iter:get_arg_type() == ldbus.types.array)

  ip_record = top_iter:recurse()
  while true do
    if not (ip_record:get_arg_type() == ldbus.types.struct) then
      return kres.DONE
    end

    data = ip_record:recurse()
    ip_type = data:get_basic()

    if (ip_type == 2 and type == kres.type.A) or (ip_type == 10 and type == kres.type.AAAA) then
      local addr = {}
      if not data:next() then break end
      assert(data:get_arg_type() == ldbus.types.array)
      local ip = data:recurse()
      while true do
        local raw = ip:get_basic()
        if ip_type == 2 then
          raw = string.char(raw)
        end

        table.insert(addr, raw)
        if not ip:next() then break end
      end

      if ip_type == 2 then
        answer:begin(kres.section.ANSWER)
        answer:put(qry.sname, 900, answer:qclass(), kres.type.A, table.concat(addr, ""))
        return kres.DONE
      else
        first_block = (addr[1] * 256) + addr[2]
        if not (65152 <= first_block and first_block <= 65215) then -- fe80::/10
          local out = {}
          for i=1,16,1 do
            table.insert(out, string.char(addr[i]))
          end
          answer:begin(kres.section.ANSWER)
          answer:put(qry.sname, 900, answer:qclass(), kres.type.AAAA, table.concat(out, ""))
          return kres.DONE
        end
      end
    end

    if not ip_record:next() then break end
  end

  return kres.DONE
end
