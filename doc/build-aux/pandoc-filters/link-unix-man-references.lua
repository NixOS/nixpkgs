--[[
Turns a manpage reference into a link, when a mapping is defined below.
]]

local man_urls = {
  ["nix.conf(5)"] = "https://nixos.org/manual/nix/stable/#sec-conf-file",

  ["journald.conf(5)"] = "https://www.freedesktop.org/software/systemd/man/journald.conf.html",
  ["logind.conf(5)"] = "https://www.freedesktop.org/software/systemd/man/logind.conf.html",
  ["networkd.conf(5)"] = "https://www.freedesktop.org/software/systemd/man/networkd.conf.html",
  ["systemd.automount(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.automount.html",
  ["systemd.exec(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.exec.html",
  ["systemd.link(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.link.html",
  ["systemd.mount(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.mount.html",
  ["systemd.netdev(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.netdev.html",
  ["systemd.network(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.network.html",
  ["systemd.nspawn(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.nspawn.html",
  ["systemd.path(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.path.html",
  ["systemd.resource-control(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html",
  ["systemd.scope(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.scope.html",
  ["systemd.service(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.service.html",
  ["systemd.slice(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.slice.html",
  ["systemd.socket(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.socket.html",
  ["systemd.timer(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.timer.html",
  ["systemd.unit(5)"] = "https://www.freedesktop.org/software/systemd/man/systemd.unit.html",
  ["timesyncd.conf(5)"] = "https://www.freedesktop.org/software/systemd/man/timesyncd.conf.html",
  ["tmpfiles.d(5)"] = "https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html",
  ["systemd.time(7)"] = "https://www.freedesktop.org/software/systemd/man/systemd.time.html",
  ["systemd-fstab-generator(8)"] = "https://www.freedesktop.org/software/systemd/man/systemd-fstab-generator.html",
  ["systemd-networkd-wait-online.service(8)"] = "https://www.freedesktop.org/software/systemd/man/systemd-networkd-wait-online.service.html",
}

function Code(elem)
  local is_man_role = elem.classes:includes('interpreted-text') and elem.attributes['role'] == 'manpage'
  if is_man_role and man_urls[elem.text] ~= nil then
    return pandoc.Link(elem, man_urls[elem.text])
  end
end
