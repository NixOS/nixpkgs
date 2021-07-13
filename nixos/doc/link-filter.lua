function Link(elem)
  if #elem.content == 1 and elem.content[1].tag == 'Str' and elem.content[1].text == '???' then
    -- Pandoc’s DocBook reader uses ??? for the link text when it cannot find xref target.
    -- That can happen when the target is located in another file.
    -- We support automatic cross-references as links with empty text so let’s make use of them.
    elem.content[1].text = ''

    return elem
  end
end
