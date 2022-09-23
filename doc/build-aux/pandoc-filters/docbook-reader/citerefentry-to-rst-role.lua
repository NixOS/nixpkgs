--[[
Converts Code AST nodes produced by pandoc’s DocBook reader
from citerefentry elements into AST for corresponding role
for reStructuredText.

We use subset of MyST syntax (CommonMark with features from rST)
so let’s use the rST AST for rST features.

Reference: https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#role-manpage
]]

function Code(elem)
  elem.classes = elem.classes:map(function (x)
    if x == 'citerefentry' then
      elem.attributes['role'] = 'manpage'
      return 'interpreted-text'
    else
      return x
    end
  end)

  return elem
end
