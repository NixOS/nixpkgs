{ pkgs, lib, ... }:

let

  radicale_calendars = {
    type = "caldav";
    url = "http://localhost:5232/";
    # Radicale needs username/password.
    username = "alice";
    password = "password";
  };

  radicale_contacts = {
    type = "carddav";
    url = "http://localhost:5232/";
    # Radicale needs username/password.
    username = "alice";
    password = "password";
  };

  xandikos_calendars = {
    type = "caldav";
    url = "http://localhost:8080/user/calendars";
    # Xandikos warns
    # > No current-user-principal returned, re-using URL http://localhost:8080/user/calendars/
    # but we do not need username/password.
  };

  xandikos_contacts = {
    type = "carddav";
    url = "http://localhost:8080/user/contacts";
  };

  local_calendars = {
    type = "filesystem";
    path = "~/calendars";
    fileext = ".ics";
  };

  local_contacts = {
    type = "filesystem";
    path = "~/contacts";
    fileext = ".vcf";
  };

  mkPairs = a: b: {
    calendars = {
      a = "${a}_calendars";
      b = "${b}_calendars";
      collections = [
        "from a"
        "from b"
      ];
    };
    contacts = {
      a = "${a}_contacts";
      b = "${b}_contacts";
      collections = [
        "from a"
        "from b"
      ];
    };
  };

  mkRadicaleProps =
    tag:
    pkgs.writeText "Radicale.props" (
      builtins.toJSON {
        inherit tag;
      }
    );

  writeLines =
    name: eol: lines:
    pkgs.writeText name (lib.concatMapStrings (l: "${l}${eol}") lines);

  prodid = "-//NixOS test//EN";
  dtstamp = "20231129T194743Z";

  writeICS =
    {
      uid,
      summary,
      dtstart,
      dtend,
    }:
    writeLines "${uid}.ics" "\r\n" [
      "BEGIN:VCALENDAR"
      "VERSION:2.0"
      "PRODID:${prodid}"
      "BEGIN:VEVENT"
      "UID:${uid}"
      "SUMMARY:${summary}"
      "DTSTART:${dtstart}"
      "DTEND:${dtend}"
      "DTSTAMP:${dtstamp}"
      "END:VEVENT"
      "END:VCALENDAR"
    ];

  foo_ics = writeICS {
    uid = "foo";
    summary = "Epochalypse";
    dtstart = "19700101T000000Z";
    dtend = "20380119T031407Z";
  };

  bar_ics = writeICS {
    uid = "bar";
    summary = "One Billion Seconds";
    dtstart = "19700101T000000Z";
    dtend = "20010909T014640Z";
  };

  writeVCF =
    {
      uid,
      name,
      displayName,
      email,
    }:
    writeLines "${uid}.vcf" "\r\n" [
      # One of the tools enforces this order of fields.
      "BEGIN:VCARD"
      "VERSION:4.0"
      "UID:${uid}"
      "EMAIL;TYPE=INTERNET:${email}"
      "FN:${displayName}"
      "N:${name}"
      "END:VCARD"
    ];

  foo_vcf = writeVCF {
    uid = "foo";
    name = "Doe;John;;;";
    displayName = "John Doe";
    email = "john.doe@example.org";
  };

  bar_vcf = writeVCF {
    uid = "bar";
    name = "Doe;Jane;;;";
    displayName = "Jane Doe";
    email = "jane.doe@example.org";
  };

in
{
  name = "vdirsyncer";

  meta.maintainers = with lib.maintainers; [ schnusch ];

  nodes = {
    machine = {
      services.radicale = {
        enable = true;
        settings.auth.type = "none";
      };

      services.xandikos = {
        enable = true;
        extraOptions = [ "--autocreate" ];
      };

      services.vdirsyncer = {
        enable = true;
        jobs = {

          alice = {
            user = "alice";
            group = "users";
            config = {
              statusPath = "/home/alice/.vdirsyncer";
              storages = {
                inherit
                  local_calendars
                  local_contacts
                  radicale_calendars
                  radicale_contacts
                  ;
              };
              pairs = mkPairs "local" "radicale";
            };
            forceDiscover = true;
          };

          bob = {
            user = "bob";
            group = "users";
            config = {
              statusPath = "/home/bob/.vdirsyncer";
              storages = {
                inherit
                  local_calendars
                  local_contacts
                  xandikos_calendars
                  xandikos_contacts
                  ;
              };
              pairs = mkPairs "local" "xandikos";
            };
            forceDiscover = true;
          };

          remote = {
            config = {
              storages = {
                inherit
                  radicale_calendars
                  radicale_contacts
                  xandikos_calendars
                  xandikos_contacts
                  ;
              };
              pairs = mkPairs "radicale" "xandikos";
            };
            forceDiscover = true;
          };

        };
      };

      users.users = {
        alice.isNormalUser = true;
        bob.isNormalUser = true;
      };
    };
  };

  testScript = ''
    def run_unit(name):
        machine.systemctl(f"start {name}")
        # The service is Type=oneshot without RemainAfterExit=yes. Once it
        # is finished it is no longer active and wait_for_unit will fail.
        # When that happens we check if it actually failed.
        try:
            machine.wait_for_unit(name)
        except:
            machine.fail(f"systemctl is-failed {name}")

    start_all()

    machine.wait_for_open_port(5232)
    machine.wait_for_open_port(8080)
    machine.wait_for_unit("multi-user.target")

    with subtest("alice -> radicale"):
        # vdirsyncer cannot create create collections on Radicale,
        # see https://vdirsyncer.pimutils.org/en/stable/tutorials/radicale.html
        machine.succeed("runuser -u radicale -- install -Dm 644 ${mkRadicaleProps "VCALENDAR"} /var/lib/radicale/collections/collection-root/alice/foocal/.Radicale.props")
        machine.succeed("runuser -u radicale -- install -Dm 644 ${mkRadicaleProps "VADDRESSBOOK"} /var/lib/radicale/collections/collection-root/alice/foocard/.Radicale.props")

        machine.succeed("runuser -u alice -- install -Dm 644 ${foo_ics} /home/alice/calendars/foocal/foo.ics")
        machine.succeed("runuser -u alice -- install -Dm 644 ${foo_vcf} /home/alice/contacts/foocard/foo.vcf")
        run_unit("vdirsyncer@alice.service")

        # test statusPath
        machine.succeed("test -d /home/alice/.vdirsyncer")
        machine.fail("test -e /var/lib/private/vdirsyncer/alice")

    with subtest("bob -> xandikos"):
        # I suspect Radicale shares the namespace for calendars and
        # contacts, but Xandikos separates them. We just use `barcal` and
        # `barcard` with Xandikos as well to avoid conflicts.
        machine.succeed("runuser -u bob -- install -Dm 644 ${bar_ics} /home/bob/calendars/barcal/bar.ics")
        machine.succeed("runuser -u bob -- install -Dm 644 ${bar_vcf} /home/bob/contacts/barcard/bar.vcf")
        run_unit("vdirsyncer@bob.service")

        # test statusPath
        machine.succeed("test -d /home/bob/.vdirsyncer")
        machine.fail("test -e /var/lib/private/vdirsyncer/bob")

    with subtest("radicale <-> xandikos"):
        # vdirsyncer cannot create create collections on Radicale,
        # see https://vdirsyncer.pimutils.org/en/stable/tutorials/radicale.html
        machine.succeed("runuser -u radicale -- install -Dm 644 ${mkRadicaleProps "VCALENDAR"} /var/lib/radicale/collections/collection-root/alice/barcal/.Radicale.props")
        machine.succeed("runuser -u radicale -- install -Dm 644 ${mkRadicaleProps "VADDRESSBOOK"} /var/lib/radicale/collections/collection-root/alice/barcard/.Radicale.props")

        run_unit("vdirsyncer@remote.service")

        # test statusPath
        machine.succeed("test -d /var/lib/private/vdirsyncer/remote")

    with subtest("radicale -> alice"):
        run_unit("vdirsyncer@alice.service")

    with subtest("xandikos -> bob"):
        run_unit("vdirsyncer@bob.service")

    with subtest("compare synced files"):
        # iCalendar files get reordered
        machine.succeed("diff -u --strip-trailing-cr <(sort /home/alice/calendars/foocal/foo.ics) <(sort /home/bob/calendars/foocal/foo.ics) >&2")
        machine.succeed("diff -u --strip-trailing-cr <(sort /home/bob/calendars/barcal/bar.ics) <(sort /home/alice/calendars/barcal/bar.ics) >&2")

        machine.succeed("diff -u --strip-trailing-cr /home/alice/contacts/foocard/foo.vcf /home/bob/contacts/foocard/foo.vcf >&2")
        machine.succeed("diff -u --strip-trailing-cr /home/bob/contacts/barcard/bar.vcf /home/alice/contacts/barcard/bar.vcf >&2")
  '';
}
