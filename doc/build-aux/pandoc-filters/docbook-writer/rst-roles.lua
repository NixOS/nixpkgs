--[[
Converts AST for reStructuredText roles into corresponding
DocBook elements.

Currently, only a subset of roles is supported.

Reference:
  List of roles:
    https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html
  manpage:
    https://tdg.docbook.org/tdg/5.1/citerefentry.html
  file:
    https://tdg.docbook.org/tdg/5.1/filename.html
]]

function Code(elem)
  if elem.classes:includes('interpreted-text') then
    local tag = nil
    local content = elem.text
    if elem.attributes['role'] == 'manpage' then
      tag = 'citerefentry'
      local title, volnum = content:match('^(.+)%((%w+)%)$')
      if title == nil then
        -- No volnum in parentheses.
        title = content
      end
      content = '<refentrytitle>' .. title .. '</refentrytitle>' .. (volnum ~= nil and ('<manvolnum>' .. volnum .. '</manvolnum>') or '')
    elseif elem.attributes['role'] == 'file' then
      tag = 'filename'
    elseif elem.attributes['role'] == 'command' then
      tag = 'command'
    elseif elem.attributes['role'] == 'option' then
      tag = 'option'
    end

    if tag ~= nil then
      return pandoc.RawInline('docbook', '<' .. tag .. '>' .. content .. '</' .. tag .. '>')
    end
  end
end
