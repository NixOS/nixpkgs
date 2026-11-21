import nixos_render_docs as nrd
import textwrap

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

def test_table_two_columns() -> None:
    c = Converter({})
    assert c._render(textwrap.dedent("""
      | key | value |
      |-----|-------|
      | foo | bar   |
    """)) == (
        '\n\n'
        '[cols="<,<",options="header"]\n'
        '|===\n'
        '| key | value\n'
        '\n'
        '| foo | bar\n'
        '|===\n'
    )

def test_table_many_columns() -> None:
    c = Converter({})
    assert c._render(textwrap.dedent("""
      | d | l | m |
      |---|---|---|
      | a | b | c |
      | x | y | z |
    """)) == (
        '\n\n'
        '[cols="<,<,<",options="header"]\n'
        '|===\n'
        '| d | l | m\n'
        '\n'
        '| a | b | c\n'
        '| x | y | z\n'
        '|===\n'
    )

def test_table_single_column() -> None:
    c = Converter({})
    assert c._render(textwrap.dedent("""
      | key |
      |-----|
      | foo |
    """)) == (
        '\n\n'
        '[cols="<",options="header"]\n'
        '|===\n'
        '| key\n'
        '\n'
        '| foo\n'
        '|===\n'
    )

def test_table_column_alignment() -> None:
    c = Converter({})
    assert c._render(textwrap.dedent("""
      | l | c | r |
      |:--|:-:|--:|
      | a | b | c |
    """)) == (
        '\n\n'
        '[cols="<,^,>",options="header"]\n'
        '|===\n'
        '| l | c | r\n'
        '\n'
        '| a | b | c\n'
        '|===\n'
    )

def test_table_empty_cell() -> None:
    c = Converter({})
    assert c._render(textwrap.dedent("""
      | key |
      |-----|
      |     |
    """)) == (
        '\n\n'
        '[cols="<",options="header"]\n'
        '|===\n'
        '| key\n'
        '\n'
        '| \n'
        '|===\n'
    )
    assert c._render(textwrap.dedent("""
      | a | b |
      |---|---|
      |   | x |
    """)) == (
        '\n\n'
        '[cols="<,<",options="header"]\n'
        '|===\n'
        '| a | b\n'
        '\n'
        '|  | x\n'
        '|===\n'
    )

def test_table_escapes_content() -> None:
    c = Converter({})
    assert c._render(textwrap.dedent("""
      | key   | value        |
      |-------|--------------|
      | a-b   | *em* \\| `c` |
    """)) == (
        '\n\n'
        '[cols="<,<",options="header"]\n'
        '|===\n'
        '| key | value\n'
        '\n'
        '| a-b | __em__ {vbar} ``c``\n'
        '|===\n'
    )

def test_full() -> None:
    c = Converter({ 'man(1)': 'http://example.org' })
    assert c._render(sample1) == """\
[NOTE]
====
This is a __GFM__ note{zwsp}.

[CAUTION]
=====
This is a **nested** GFM alert{zwsp}.
=====

====


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


[cols="<,<",options="header"]
|===
| this | is

| a | table
|===
"""
