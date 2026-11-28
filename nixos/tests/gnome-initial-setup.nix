{ pkgs, lib, ... }:
{
  name = "gnome-initial-setup";
  meta.maintainers = lib.teams.gnome.members;

  nodes.machine =
    { config, ... }:

    {
      i18n = {
        # So the locale can be changed to "en_US.UTF-8" during the test.
        defaultLocale = "C.UTF-8";
        # So the locale can be changed imperatively
        imperativeLocale = true;
      };

      services.displayManager.gdm = {
        enable = true;
        debug = true;
      };

      services.desktopManager.gnome = {
        enable = true;
        debug = true;
      };

      services.gnome.gnome-initial-setup = {
        enable = true;
        settings.pages.skip = [
          "network"
          "privacy"
          "parental_controls"
          "parent_password"
        ];
      };

      # So the keyboard can be changed to "us" during the test.
      services.xserver.xkb.layout = "gb";

      systemd.user.services = {
        gnome-initial-setup.environment.G_MESSAGES_DEBUG = "all";
        gnome-initial-setup-first-login.environment.G_MESSAGES_DEBUG = "all";
        gnome-initial-setup-copy-worker.environment.G_MESSAGES_DEBUG = "all";

        "org.gnome.Shell@" = {
          serviceConfig = {
            ExecStart = [
              # Clear the list before overriding it.
              ""
              # Eval API is now internal so Shell needs to run in unsafe mode.
              # TODO: improve test driver so that it supports openqa-like manipulation
              # that would allow us to drop this mess.
              "${pkgs.gnome-shell}/bin/gnome-shell --mode=%i --unsafe-mode"
            ];
          };
        };
      };

      # So the time zone can be changed imperatively
      time.timeZone = null;

      # So users can be changed imperatively
      users.mutableUsers = true;
    };

  testScript =
    { nodes, ... }:
    let
      userName = "alice";
      userDescription = "Alice Foobar";
      password = "foobar";
    in
    ''
      from datetime import timedelta
      import json

      gis_user = "gnome-initial-setup"

      def wait_until_application_started(id, user):
          def check_success(_):
              status, uid = machine.execute(f"id -u {user}")
              if status != 0:
                  return False
              uid = uid.strip()

              bus = f"DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/{uid}/bus"
              eval = "busctl --user --json=short call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s global.display.focus_window.wm_class"
              run = f"su -s /bin/sh {user} -c '{bus} {eval}'"
              status, out = machine.execute(run)
              if status != 0:
                  return False

              try:
                  wm_class = json.loads(out)
                  return bool(wm_class["data"][0] and id in wm_class["data"][1])
              except Exception:
                  return False

          with machine.nested(f"waiting until '{id}' has started"):
              retry(check_success)


      def wait_until_user(user):
          def check_success(_):
              status, out = machine.execute(f"getent passwd {user}")
              if status != 0:
                  return False

              out = out.strip()
              passwd_user = out.split(":")[0]
              return passwd_user == user

          with machine.nested(f"waiting until the '{user}' exists"):
              retry(check_success)


      def wait_until_password(user):
          def check_success(_):
              status, out = machine.execute(f"getent shadow {user}")
              if status != 0:
                  return False

              out = out.strip()
              password_hash = out.split(":")[1]
              return password_hash.startswith("$")

          with machine.nested(f"waiting until the password of '{user}' is set"):
              retry(check_success)


      def wait_until_lang_matches(lang):
          def check_success(_):
              status, out = machine.execute(
                  "busctl get-property --json=short org.freedesktop.locale1 /org/freedesktop/locale1 org.freedesktop.locale1 Locale"
              )
              if status != 0:
                  return False
              try:
                  locale = json.loads(out)
                  return f"LANG={lang}" in locale["data"]
              except Exception:
                  return False

          with machine.nested(f"waiting for the language to match '{lang}'"):
              retry(check_success)


      def wait_until_layout_matches(layout):
          def check_success(_):
              status, out = machine.execute(
                  "busctl get-property --json=short org.freedesktop.locale1 /org/freedesktop/locale1 org.freedesktop.locale1 X11Layout"
              )
              if status != 0:
                  return False
              try:
                  x11_layout = json.loads(out)
                  return layout in x11_layout["data"]
              except Exception:
                  return False

          with machine.nested(f"waiting for the keyboard layout to match '{layout}'"):
              retry(check_success)


      def wait_until_time_zone_matches(time_zone):
          def check_success(_):
              status, out = machine.execute(
                  "busctl get-property --json=short org.freedesktop.timedate1 /org/freedesktop/timedate1 org.freedesktop.timedate1 Timezone"
              )
              if status != 0:
                  return False
              try:
                  tz = json.loads(out)
                  return tz["data"] == time_zone
              except Exception:
                  return False

          with machine.nested(f"waiting for the time zone to match '{time_zone}'"):
              retry(check_success)


      with subtest("Wait for GNOME Initial Setup to start"):
          # wait for gdm to start
          machine.wait_for_unit("display-manager.service")
          # the gnome-initial-setup user does not have a static uid
          gis_uid = machine.succeed(f"id -u {gis_user}").strip()
          # wait for the wayland server
          machine.wait_for_file(f"/run/user/{gis_uid}/wayland-0")
          # wait for the gnome-initial-setup user to be logged in
          machine.wait_for_unit("default.target", gis_user)
          # check that logging in has given the user ownership of devices
          assert gis_user in machine.succeed("getfacl -p /dev/snd/timer")
          # wait for gdm to start gnome-initial-setup.session
          machine.wait_for_unit("gnome-session-manager@gnome-initial-setup.service", gis_user)
          machine.wait_for_unit("gnome-session.target", gis_user)
          # wait for gnome-session to start the gnome-initial-setup.service
          machine.wait_for_unit("gnome-initial-setup.service", gis_user)
          # wait for the application to start
          wait_until_application_started("org.gnome.InitialSetup", gis_user)
          machine.sleep(timedelta(seconds=2))
          machine.screenshot("welcome-page")


      with subtest("Configure the language"):
          machine.sleep(timedelta(seconds=2))
          machine.send_chars("English")
          machine.sleep(timedelta(seconds=1))
          machine.send_key("tab")
          machine.sleep(timedelta(seconds=1))
          machine.send_key("spc")
          machine.sleep(timedelta(seconds=1))
          # otherwise the screenshot does not show the selected language reliably
          machine.sleep(timedelta(seconds=2))
          machine.screenshot("language-page")
          machine.send_key("alt-n")
          wait_until_lang_matches("en_US.UTF-8")


      with subtest("Configure the keyboard"):
          machine.sleep(timedelta(seconds=2))
          machine.send_chars("English (US)")
          machine.sleep(timedelta(seconds=1))
          # skip "English (Mali, US, intl.)"
          machine.send_key("tab")
          machine.sleep(timedelta(seconds=1))
          # skip the keyboard preview
          machine.send_key("tab")
          machine.sleep(timedelta(seconds=1))
          # select "English (US)"
          # without the timeout the test is flaky and sometimes triggers
          # the keyboard preview popup, selected previously
          machine.sleep(timedelta(seconds=1))
          machine.send_key("tab")
          machine.sleep(timedelta(seconds=1))
          machine.send_key("ret")
          machine.sleep(timedelta(seconds=1))
          # wait for the selection to appear on the screenshot
          machine.sleep(timedelta(seconds=2))
          machine.screenshot("keyboard-page")
          machine.send_key("alt-n")
          wait_until_layout_matches("us")


      with subtest("Configure the time zone"):
          machine.sleep(timedelta(seconds=2))
          machine.send_chars("Amsterdam, Netherlands")
          machine.sleep(timedelta(seconds=3))
          # the list needs time to filter
          machine.send_key("down")
          machine.sleep(timedelta(seconds=1))
          # sometimes this is flaky when the VM is slow
          machine.send_key("ret")
          machine.sleep(timedelta(seconds=1))
          # wait for the selection to appear on the screenshot
          machine.sleep(timedelta(seconds=2))
          machine.screenshot("time-zone-page")
          machine.send_key("alt-n")
          wait_until_time_zone_matches("Europe/Amsterdam")


      with subtest("Configure a user account"):
          machine.sleep(timedelta(seconds=2))
          machine.send_chars("${userDescription}")
          machine.sleep(timedelta(seconds=1))
          machine.send_key("tab")
          # otherwise the username is flaky when the VM is slow
          machine.sleep(timedelta(seconds=3))
          machine.send_chars("${userName}")
          # otherwise the username is wrong and appends the password somehow
          machine.sleep(timedelta(seconds=3))
          machine.screenshot("account-page")
          machine.send_key("alt-n")

          machine.sleep(timedelta(seconds=2))
          machine.send_chars("${password}")
          machine.sleep(timedelta(seconds=1))
          # skip the password preview
          machine.send_key("tab")
          machine.sleep(timedelta(seconds=1))
          machine.send_key("tab")
          # otherwise the test is flaky and eats characters
          machine.sleep(timedelta(seconds=3))
          machine.send_chars("${password}")
          # the "Next" button needs time to be enabled
          machine.sleep(timedelta(seconds=3))
          machine.screenshot("password-page")
          machine.send_key("alt-n")

          # wait for AccountsService to create the user
          wait_until_user("${userName}")
          wait_until_password("${userName}")
          groups = machine.succeed("id -Gn ${userName}").split()
          assert "wheel" in groups, f"expected 'wheel' in groups, got: {groups}"
          assert "users" in groups, f"expected 'users' in groups, got: {groups}"


      with subtest("Finish the setup and log into the desktop"):
          machine.sleep(timedelta(seconds=2))
          machine.screenshot("summary-page")
          machine.send_key("alt-s")

          uid = machine.succeed("id -u ${userName}").strip()
          machine.wait_for_file(f"/run/user/{uid}/wayland-0")
          machine.wait_for_unit("default.target", "${userName}")
          # check that logging in has given the user ownership of devices
          assert "${userName}" in machine.succeed("getfacl -p /dev/snd/timer")
          # these file are created by gnome-initial-setup-copy-worker by copying
          # from /run/gdm/gnome-initial-setup/
          machine.wait_for_file("/home/${userName}/.config/gnome-initial-setup-done")
          machine.wait_for_file("/home/${userName}/.config/dconf/user")
          # wait for the desktop to appear on the screenshot
          machine.sleep(timedelta(seconds=2))
          machine.screenshot("desktop")
    '';
}
