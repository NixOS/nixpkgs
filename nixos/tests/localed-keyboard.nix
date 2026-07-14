# Checks that systemd-localed reports the X11 keyboard configuration from the
# generated /etc/X11/xorg.conf.d/00-keyboard.conf. Compositors such as kwin
# (kwin_wayland --locale1, used by the SDDM greeter) read the keymap from the
# org.freedesktop.locale1 D-Bus interface, so localed failing to parse the file
# leaves them on the default us layout.
# Regression test for https://github.com/systemd/systemd/issues/43007.
{ ... }:
{
  name = "localed-keyboard";
  meta.maintainers = [ ];

  nodes = {
    # xkb.variant deliberately left at its default "": empty values must not
    # end up in 00-keyboard.conf, where systemd-localed (since v261) treats
    # them as invalid and then discards the whole file.
    default_variant = {
      services.graphical-desktop.enable = true;
      services.xserver.xkb.layout = "gb";
    };

    with_variant = {
      services.graphical-desktop.enable = true;
      services.xserver.xkb.layout = "gb";
      services.xserver.xkb.variant = "extd";
    };
  };

  testScript = ''
    start_all()

    default_variant.wait_for_unit("multi-user.target")
    out = default_variant.succeed("localectl status")
    assert "X11 Layout: gb" in out, out

    with_variant.wait_for_unit("multi-user.target")
    out = with_variant.succeed("localectl status")
    assert "X11 Layout: gb" in out, out
    assert "X11 Variant: extd" in out, out
  '';
}
