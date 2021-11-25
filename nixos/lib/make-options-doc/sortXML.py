import xml.etree.ElementTree as ET
import sys

tree = ET.parse(sys.argv[1])
# the xml tree is of the form
# <expr><list> {all options, each an attrs} </list></expr>
options = list(tree.getroot().find('list'))

def sortKey(opt):
    def order(s):
        if s.startswith("enable"):
            return 0
        if s.startswith("package"):
            return 1
        return 2

    return [
        (order(p.attrib['value']), p.attrib['value'])
        for p in opt.findall('attr[@name="loc"]/list/string')
    ]

# always ensure that the sort order matches the order used in the nix expression!
options.sort(key=sortKey)

doc = ET.Element("expr")
newOptions = ET.SubElement(doc, "list")
newOptions.extend(options)
ET.ElementTree(doc).write(sys.argv[2], encoding='utf-8')
