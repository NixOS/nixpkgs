#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=channel:nixos-unstable -i python3 -p python3 -p python3.pkgs.lxml

"""
Pandoc will strip any markup within code elements so
let’s escape them so that they can be handled manually.
"""

import lxml.etree as ET
import re
import sys

def replace_element_by_text(el: ET.Element, text: str) -> None:
    """
    Author: bernulf
    Source: https://stackoverflow.com/a/10520552/160386
    SPDX-License-Identifier: CC-BY-SA-3.0
    """
    text = text + (el.tail or "")
    parent = el.getparent()
    if parent is not None:
        previous = el.getprevious()
        if previous is not None:
            previous.tail = (previous.tail or "") + text
        else:
            parent.text = (parent.text or "") + text
        parent.remove(el)

DOCBOOK_NS = "http://docbook.org/ns/docbook"

# List of elements that pandoc’s DocBook reader strips markup from.
# https://github.com/jgm/pandoc/blob/master/src/Text/Pandoc/Readers/DocBook.hs
code_elements = [
    # CodeBlock
    "literallayout",
    "screen",
    "programlisting",
    # Code (inline)
    "classname",
    "code",
    "filename",
    "envar",
    "literal",
    "computeroutput",
    "prompt",
    "parameter",
    "option",
    "markup",
    "wordasword",
    "command",
    "varname",
    "function",
    "type",
    "symbol",
    "constant",
    "userinput",
    "systemitem",
]

XMLNS_REGEX = re.compile(r'\s+xmlns(?::[^=]+)?="[^"]*"')
ROOT_ELEMENT_REGEX = re.compile(r'^\s*<[^>]+>')

def remove_xmlns(match: re.Match) -> str:
    """
    Removes xmlns attributes.

    Expects a match containing an opening tag.
    """
    return XMLNS_REGEX.sub('', match.group(0))

if __name__ == '__main__':
    assert len(sys.argv) >= 3, "usage: escape-code-markup.py <input> <output>"

    tree = ET.parse(sys.argv[1])
    name_predicate = " or ".join([f"local-name()='{el}'" for el in code_elements])

    for markup in tree.xpath(f"//*[({name_predicate}) and namespace-uri()='{DOCBOOK_NS}']/*"):
        text = ET.tostring(markup, encoding=str)

        # tostring adds xmlns attributes to the element we want to stringify
        # as if it was supposed to be usable standalone.
        # We are just converting it to CDATA so we do not care.
        # Let’s strip the namespace declarations to keep the code clean.
        #
        # Note that this removes even namespaces that were potentially
        # in the original file. Though, that should be very rare –
        # most of the time, we will stringify empty DocBook elements
        # like <xref> or <co> or, at worst, <link> with xlink:href attribute.
        #
        # Also note that the regex expects the root element to be first
        # thing in the string. But that should be fine, the tostring method
        # does not produce XML declaration or doctype by default.
        text = ROOT_ELEMENT_REGEX.sub(remove_xmlns, text)

        replace_element_by_text(markup, text)

    tree.write(sys.argv[2])
