--[[
Converts some HTML elements commonly used in Markdown to corresponding DocBook elements.
]]

function RawInline(elem)
  if elem.format == 'html' and elem.text == '<kbd>' then
    return pandoc.RawInline('docbook', '<keycap>')
  elseif elem.format == 'html' and elem.text == '</kbd>' then
    return pandoc.RawInline('docbook', '</keycap>')
  end
end
