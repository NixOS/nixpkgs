--[[
Turns a manpage reference into a link, when a mapping is defined below.
]]

local man_urls = {
  ["tmpfiles.d(5)"] = "https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html",
  ["nix.conf(5)"] = "https://nixos.org/manual/nix/stable/#sec-conf-file",
  ["systemd.time(7)"] = "https://www.freedesktop.org/software/systemd/man/systemd.time.html",
  ["systemd.timer(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.timer.html",
}

function Code(elem)
  local is_man_role = elem.classes:includes('interpreted-text') and elem.attributes['role'] == 'manpage'
  if is_man_role and man_urls[elem.text] ~= nil then
    return pandoc.Link(elem, man_urls[elem.text])
  end
end
