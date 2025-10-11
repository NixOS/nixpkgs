{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:
buildGoModule rec {
  pname = "docopts";
  version = "0.6.4-with-no-mangle-double-dash";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = "docopts";
    tag = "v${version}";
    hash = "sha256-GIBrJ5qexeJ6ul5ek9LJZC4J3cNExsTrnxdzRCfoqn8=";
  };

  patches = [
    # Migrate project to Go modules.
    (fetchpatch {
      url = "https://github.com/docopt/docopts/pull/74/commits/2c516165e72b35516a64c4529dbc938c0aaa9442.patch";
      hash = "sha256-Tp05B3tmctnSYIQzCxCc/fhcAWWuEz2ifu/CQZt0XPU=";
    })
  ];

  postPatch =
    let
      path = lib.makeBinPath (
        with pkgs;
        [
          gawk
          coreutils
          gnugrep
        ]
      );
    in
    ''

      # Make docopts.sh get its dependencies from Nix.
      # First, next to the first non-comment line, inject code to add the
      # dependencies to the PATH.
      awk -i inplace '!inserted && !/^#/ {
        print "__NIX_OLD_PATH=\"$PATH\""
        print "PATH=\"${path}:$PATH\""
        inserted = 1
      }
      { print }' docopts.sh
      # Now, since this will be sourced by the user and we don't want to clobber
      # PATH in their scripts, add a line at the end to restore the old PATH.
      echo 'PATH="$__NIX_OLD_PPATH"' >> docopts.sh
    '';

  # Include docopts.sh, which can be sourced for a convenient interface, see:
  # https://github.com/docopt/docopts/blob/master/examples/arguments_example.sh
  postInstall = ''
    cp ./docopts.sh $out/bin/docopts.sh
  '';

  vendorHash = "sha256-+pMgaHB69itbQ+BDM7/oaJg3HrT1UN+joJL7BO/2vxE=";

  meta = {
    homepage = "https://github.com/docopt/docopts";
    description = "Shell interpreter for docopt, the command-line interface description language";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.confus ];
    platforms = lib.platforms.unix;
  };
}
