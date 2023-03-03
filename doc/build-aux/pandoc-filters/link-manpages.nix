{ pkgs ? import ../../.. {} }:
let
  inherit (pkgs) lib;
  manpageURLs = builtins.fromJSON (builtins.readFile (pkgs.path + "/doc/manpage-urls.json"));
in pkgs.writeText "link-manpages.lua" ''
  --[[
  Adds links to known man pages that aren't already in a link.
  ]]

  local manpage_urls = {
  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (man: url:
    "  [${builtins.toJSON man}] = ${builtins.toJSON url},") manpageURLs)}
  }

  traverse = 'topdown'

  -- Returning false as the second value aborts processing of child elements.
  function Link(elem)
    return elem, false
  end

  function Code(elem)
    local is_man_role = elem.classes:includes('interpreted-text') and elem.attributes['role'] == 'manpage'
    if is_man_role and manpage_urls[elem.text] ~= nil then
      return pandoc.Link(elem, manpage_urls[elem.text]), false
    end
  end
''
