import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    manImplementations = [
      "mandoc"
      "man-db"
    ];

    machineNames = builtins.map machineSafe manImplementations;

    makeConfig = useImpl: {
      # Note: mandoc currently can't index symlinked section directories.
      # So if a man section comes from one package exclusively (e. g.
      # 1p from man-pages-posix and 2 from man-pages), it isn't searchable.
      environment.systemPackages = [
        pkgs.man-pages
        pkgs.openssl
        pkgs.libunwind
      ];

      documentation = {
        enable = true;
        nixos.enable = lib.mkForce true;
        dev.enable = true;
        man =
          {
            enable = true;
            generateCaches = true;
          }
          // lib.listToAttrs (
            builtins.map (impl: {
              name = impl;
              value = {
                enable = useImpl == impl;
              };
            }) manImplementations
          );
      };
    };

    machineSafe = builtins.replaceStrings [ "-" ] [ "_" ];
  in
  {
    name = "man";
    meta.maintainers = [ lib.maintainers.sternenseemann ];

    nodes = lib.listToAttrs (
      builtins.map (i: {
        name = machineSafe i;
        value = makeConfig i;
      }) manImplementations
    );

    testScript =
      ''
        import re
        start_all()

        def match_man_k(page, section, haystack):
          """
          Check if the man page {page}({section}) occurs in
          the output of `man -k` given as haystack. Note:
          This is not super reliable, e. g. it can't deal
          with man pages that are in multiple sections.
          """

          for line in haystack.split("\n"):
            # man -k can look like this:
            # page(3) - bla
            # page (3) - bla
            # pagea, pageb (3, 3P) - foo
            # pagea, pageb, pagec(3) - bar
            pages = line.split("(")[0]
            sections = re.search("\\([a-zA-Z1-9, ]+\\)", line)
            if sections is None:
              continue
            else:
              sections = sections.group(0)[1:-1]

            if page in pages and f'{section}' in sections:
              return True

          return False

      ''
      + lib.concatMapStrings (machine: ''
        with subtest("Test direct man page lookups in ${machine}"):
          # man works
          ${machine}.succeed("man man > /dev/null")
          # devman works
          ${machine}.succeed("man 3 libunwind > /dev/null")
          # NixOS configuration man page is installed
          ${machine}.succeed("man configuration.nix > /dev/null")

        with subtest("Test generateCaches via man -k in ${machine}"):
          expected = [
            ("openssl", "ssl", 3),
            ("unwind", "libunwind", 3),
            ("user", "useradd", 8),
            ("user", "userdel", 8),
            ("mem", "free", 3),
            ("mem", "free", 1),
          ]

          for (keyword, page, section) in expected:
            matches = ${machine}.succeed(f"man -k {keyword}")
            if not match_man_k(page, section, matches):
              raise Exception(f"{page}({section}) missing in matches: {matches}")
      '') machineNames;
  }
)
