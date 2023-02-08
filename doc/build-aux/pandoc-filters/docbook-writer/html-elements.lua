--[[
Converts some HTML elements commonly used in Markdown to corresponding DocBook elements.
]]

function Span(elem)
  if #elem.classes == 1 and elem.classes[1] == 'keycap' then
    elem.content:insert(1, pandoc.RawInline('docbook', '<keycap>'))
    elem.content:insert(pandoc.RawInline('docbook', '</keycap>'))
    return elem
  end
end
