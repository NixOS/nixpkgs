import nixos_render_docs as nrd

from sample_md import sample1

class Converter(nrd.md.Converter[nrd.asciidoc.AsciiDocRenderer]):
    def __init__(self, manpage_urls: dict[str, str]):
        super().__init__()
        self._renderer = nrd.asciidoc.AsciiDocRenderer(manpage_urls)

def test_lists() -> None:
    c = Converter({})
    # attaching to the nth ancestor list requires n newlines before the +
    assert c._render("""\
- a

  b
- c
  - d
    - e

      1

  f
""") == """\
[]
* {empty}a
+
b

* {empty}c
+
[options="compact"]
** {empty}d
+
[]
** {empty}e
+
1


+
f
"""

def test_full() -> None:
    c = Converter({ 'man(1)': 'http://example.org' })
    assert c._render(sample1) == """\
[WARNING]
====
foo

[NOTE]
=====
nested
=====

====


link:link[ multiline ]

link:http://example.org[man(1)] reference

[[b]]some [[a]]nested anchors

__emph__ **strong** __nesting emph **and strong** and ``code``__

[]
* {empty}wide bullet

* {empty}list


[]
. {empty}wide ordered

. {empty}list


[options="compact"]
* {empty}narrow bullet

* {empty}list


[options="compact"]
. {empty}narrow ordered

. {empty}list


[quote]
====
quotes

[quote]
=====
with __nesting__

----
nested code block
----
=====

[options="compact"]
* {empty}and lists

* {empty}
+
----
containing code
----


and more quote
====

[start=100,options="compact"]
. {empty}list starting at 100

. {empty}goes on


[]

deflist:: {empty}
+
[quote]
=====
with a quote and stuff
=====
+
----
code block
----
+
----
fenced block
----
+
text


more stuff in same deflist:: {empty}foo
"""
