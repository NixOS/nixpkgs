--[[
Replaces Code nodes with attrs that would be produced by rST reader
from the role syntax by a Str AST node containing {role}, followed by a Code node.

This is to emulate MyST syntax in Pandoc.
(MyST is a CommonMark flavour with rST features mixed in.)

Reference: https://myst-parser.readthedocs.io/en/latest/syntax/syntax.html#roles-an-in-line-extension-point
]]

function Code(elem)
  local role = elem.attributes['role']

  if elem.classes:includes('interpreted-text') and role ~= nil then
    elem.classes = elem.classes:filter(function (c)
      return c ~= 'interpreted-text'
    end)
    elem.attributes['role'] = nil

    return {
      pandoc.Str('{' .. role .. '}'),
      elem,
    }
  end
end
