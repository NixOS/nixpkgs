local function starts_with(start, str)
  return str:sub(1, #start) == start
end

local function escape_xml_arg(arg)
  amps = arg:gsub('&', '&amp;')
  amps_quotes = amps:gsub('"', '&quot;')
  amps_quotes_lt = amps_quotes:gsub('<', '&lt;')

  return amps_quotes_lt
end

function Link(elem)
  has_no_content = #elem.content == 0
  targets_anchor = starts_with('#', elem.target)
  has_no_attributes = elem.title == '' and elem.identifier == '' and #elem.classes == 0 and #elem.attributes == 0

  if has_no_content and targets_anchor and has_no_attributes then
    -- xref expects idref without the pound-sign
    target_without_hash = elem.target:sub(2, #elem.target)

    return pandoc.RawInline('docbook', '<xref linkend="' .. escape_xml_arg(target_without_hash) .. '" />')
  end
end
