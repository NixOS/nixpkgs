{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, channelMap ? {
    stable = pkgs.chromium;
    beta   = pkgs.chromiumBeta;
    dev    = pkgs.chromiumDev;
  }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

mapAttrs (channel: chromiumPkg: makeTest rec {
  name = "chromium-${channel}";
  meta = {
    maintainers = with maintainers; [ aszlig ];
    # https://github.com/NixOS/hydra/issues/591#issuecomment-435125621
    inherit (chromiumPkg.meta) timeout;
  };

  enableOCR = true;

  machine.imports = [ ./common/user-account.nix ./common/x11.nix ];
  machine.virtualisation.memorySize = 2047;
  machine.test-support.displayManager.auto.user = "alice";
  machine.environment.systemPackages = [ chromiumPkg ];

  startupHTML = pkgs.writeText "chromium-startup.html" ''
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Chromium startup notifier</title>
    </head>
    <body onload="javascript:document.title='startup done'">
      <img src="file://${pkgs.fetchurl {
        url = "http://nixos.org/logo/nixos-hex.svg";
        sha256 = "07ymq6nw8kc22m7kzxjxldhiq8gzmc7f45kq2bvhbdm0w5s112s4";
      }}" />
    </body>
    </html>
  '';

  testScript = let
    xdo = name: text: let
      xdoScript = pkgs.writeText "${name}.xdo" text;
    in "${pkgs.xdotool}/bin/xdotool '${xdoScript}'";
  in ''
    # Run as user alice
    sub ru ($) {
      my $esc = $_[0] =~ s/'/'\\${"'"}'/gr;
      return "su - alice -c '$esc'";
    }

    sub createNewWin {
      $machine->nest("creating a new Chromium window", sub {
        $machine->execute(ru "${xdo "new-window" ''
          search --onlyvisible --name "startup done"
          windowfocus --sync
          windowactivate --sync
        ''}");
        $machine->execute(ru "${xdo "new-window" ''
          key Ctrl+n
        ''}");
      });
    }

    sub closeWin {
      Machine::retry sub {
        $machine->execute(ru "${xdo "close-window" ''
          search --onlyvisible --name "new tab"
          windowfocus --sync
          windowactivate --sync
        ''}");
        $machine->execute(ru "${xdo "close-window" ''
          key Ctrl+w
        ''}");
        for (1..20) {
          my ($status, $out) = $machine->execute(ru "${xdo "wait-for-close" ''
            search --onlyvisible --name "new tab"
          ''}");
          return 1 if $status != 0;
          $machine->sleep(1);
        }
      }
    }

    sub waitForNewWin {
      my $ret = 0;
      $machine->nest("waiting for new Chromium window to appear", sub {
        for (1..20) {
          my ($status, $out) = $machine->execute(ru "${xdo "wait-for-window" ''
            search --onlyvisible --name "new tab"
            windowfocus --sync
            windowactivate --sync
          ''}");
          if ($status == 0) {
            $ret = 1;

            # XXX: Somehow Chromium is not accepting keystrokes for a few
            # seconds after a new window has appeared, so let's wait a while.
            $machine->sleep(10);

            last;
          }
          $machine->sleep(1);
        }
      });
      return $ret;
    }

    sub createAndWaitForNewWin {
      for (1..3) {
        createNewWin;
        return 1 if waitForNewWin;
      }
      die "new window didn't appear within 60 seconds";
    }

    sub testNewWin {
      my ($desc, $code) = @_;
      createAndWaitForNewWin;
      subtest($desc, $code);
      closeWin;
    }

    $machine->waitForX;

    my $url = "file://${startupHTML}";
    $machine->execute(ru "ulimit -c unlimited; chromium \"$url\" & disown");
    $machine->waitForText(qr/startup done/);
    $machine->waitUntilSucceeds(ru "${xdo "check-startup" ''
      search --sync --onlyvisible --name "startup done"
      # close first start help popup
      key -delay 1000 Escape
      windowfocus --sync
      windowactivate --sync
    ''}");

    createAndWaitForNewWin;
    $machine->screenshot("empty_windows");
    closeWin;

    $machine->screenshot("startup_done");

    testNewWin "check sandbox", sub {
      $machine->succeed(ru "${xdo "type-url" ''
        search --sync --onlyvisible --name "new tab"
        windowfocus --sync
        type --delay 1000 "chrome://sandbox"
      ''}");

      $machine->succeed(ru "${xdo "submit-url" ''
        search --sync --onlyvisible --name "new tab"
        windowfocus --sync
        key --delay 1000 Return
      ''}");

      $machine->screenshot("sandbox_info");

      $machine->succeed(ru "${xdo "find-window" ''
        search --sync --onlyvisible --name "sandbox status"
        windowfocus --sync
      ''}");
      $machine->succeed(ru "${xdo "copy-sandbox-info" ''
        key --delay 1000 Ctrl+a Ctrl+c
      ''}");

      my $clipboard = $machine->succeed(ru "${pkgs.xclip}/bin/xclip -o");
      die "sandbox not working properly: $clipboard"
      unless $clipboard =~ /layer 1 sandbox.*namespace/mi
          && $clipboard =~ /pid namespaces.*yes/mi
          && $clipboard =~ /network namespaces.*yes/mi
          && $clipboard =~ /seccomp.*sandbox.*yes/mi
          && $clipboard =~ /you are adequately sandboxed/mi;

      $machine->sleep(1);
      $machine->succeed(ru "${xdo "find-window-after-copy" ''
        search --onlyvisible --name "sandbox status"
      ''}");

      my $clipboard = $machine->succeed(ru "echo void | ${pkgs.xclip}/bin/xclip -i");
      $machine->succeed(ru "${xdo "copy-sandbox-info" ''
        key --delay 1000 Ctrl+a Ctrl+c
      ''}");

      my $clipboard = $machine->succeed(ru "${pkgs.xclip}/bin/xclip -o");
      die "copying twice in a row does not work properly: $clipboard"
      unless $clipboard =~ /layer 1 sandbox.*namespace/mi
          && $clipboard =~ /pid namespaces.*yes/mi
          && $clipboard =~ /network namespaces.*yes/mi
          && $clipboard =~ /seccomp.*sandbox.*yes/mi
          && $clipboard =~ /you are adequately sandboxed/mi;

      $machine->screenshot("afer_copy_from_chromium");
    };

    $machine->shutdown;
  '';
}) channelMap
