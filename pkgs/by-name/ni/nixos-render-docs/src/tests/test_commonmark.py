import nixos_render_docs as nrd

from sample_md import sample1

from typing import Mapping


class Converter(nrd.md.Converter[nrd.commonmark.CommonMarkRenderer]):
    def __init__(self, manpage_urls: Mapping[str, str]):
        super().__init__()
        self._renderer = nrd.commonmark.CommonMarkRenderer(manpage_urls)

# NOTE: in these tests we represent trailing spaces by ` ` and replace them with real space later,
# since a number of editors will strip trailing whitespace on save and that would break the tests.

def test_indented_fence() -> None:
    c = Converter({})
    s = """\
>  - ```foo
>    thing
>      
>    rest
>    ```\
""".replace(' ', ' ')
    assert c._render(s) == s

def test_full() -> None:
    c = Converter({ 'man(1)': 'http://example.org' })
    assert c._render(sample1) == """\
**Warning:** foo

**Note:** nested

[
multiline
](link)

[` man(1) `](http://example.org) reference

some nested anchors

*emph* **strong** *nesting emph **and strong** and ` code `*

 - wide bullet

 - list

 1. wide ordered

 2. list

 - narrow bullet
 - list

 1. narrow ordered
 2. list

> quotes
> 
> > with *nesting*
> > 
> > ```
> > nested code block
> > ```
> 
>  - and lists
>  - ```
>    containing code
>    ```
> 
> and more quote

 100. list starting at 100
 101. goes on

 - *‌deflist‌*
   
   > with a quote
   > and stuff
   
   ```
   code block
   ```
   
   ```
   fenced block
   ```
   
   text

 - *‌more stuff in same deflist‌*
   
   foo""".replace(' ', ' ')

def test_images() -> None:
    c = Converter({})
    assert c._render("![*alt text*](foo \"title \\\"quoted\\\" text\")") == (
        "![*alt text*](foo \"title \\\"quoted\\\" text\")"
    )
