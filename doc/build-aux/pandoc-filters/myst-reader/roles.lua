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
      -- Allow preceding punctuation (eg '('), otherwise '({file}`...`)'
      -- does not match. Also allow anything followed by a non-breaking space
      -- since pandoc emits those after certain abbreviations (e.g. e.g.).
      local prefix, role = first.text:match('^(.*){([-._+:%w]+)}$')
      if role ~= nil and (prefix == '' or prefix:match("^.*[%p ]$") ~= nil) then
        if prefix == '' then
          inlines:remove(i)
        else
          first.text = prefix
        end
        second.attributes['role'] = role
        second.classes:insert('interpreted-text')
      end
    end
  end
  return inlines
end
