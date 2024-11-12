sample1 = """\
:::: {.warning}
foo
::: {.note}
nested
:::
::::

[
  multiline
](link)

{manpage}`man(1)` reference

[some [nested]{#a} anchors]{#b}

*emph* **strong** *nesting emph **and strong** and `code`*

- wide bullet

- list

1. wide ordered

2. list

- narrow bullet
- list

1. narrow ordered
2. list

> quotes
>> with *nesting*
>>
>>     nested code block
>
> - and lists
> - ```
>   containing code
>   ```
>
> and more quote

100. list starting at 100
1. goes on

deflist
: > with a quote
  > and stuff

      code block

  ```
  fenced block
  ```

  text

more stuff in same deflist
: foo
"""
