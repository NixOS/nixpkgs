--[[
Replaces Str AST nodes containing {role}, followed by a Code node
by a Code node with attrs that would be produced by rST reader
from the role syntax.

This is to emulate MyST syntax in Pandoc.
(MyST is a CommonMark flavour with rST features mixed in.)

Reference: https://myst-parser.readthedocs.io/en/latest/syntax/syntax.html#roles-an-in-line-extension-point
]]

function Inlines(inlines)
  for i = #inlines-1,1,-1 do
    local first = inlines[i]
    local second = inlines[i+1]
    local correct_tags = first.tag == 'Str' and second.tag == 'Code'
    if correct_tags then
      -- docutils supports alphanumeric strings separated by [-._:]
      -- We are slightly more liberal for simplicity.
      local role = first.text:match('^{([-._+:%w]+)}$')
      if role ~= nil then
        inlines:remove(i)
        second.attributes['role'] = role
        second.classes:insert('interpreted-text')
      end
    end
  end
  return inlines
end
