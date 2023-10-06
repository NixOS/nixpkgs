--[[
Adds “unknown” class to CodeBlock AST nodes without any classes.

This will cause Pandoc to use fenced code block, which we prefer.
]]

function CodeBlock(elem)
  if #elem.classes == 0 then
    elem.classes:insert('unknown')
    return elem
  end
end
