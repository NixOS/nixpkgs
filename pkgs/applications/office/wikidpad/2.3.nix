#References
# http://trac.wikidpad2.webfactional.com/wiki/InstallLinux

{stdenv, lib, fetchFromGitHub, python27, makeWrapper, wrapGAppsHook}:
let
  fetchGitHubJSON = file: fetchFromGitHub { inherit (lib.importJSON file) owner repo rev sha256; };

  # example: nix-shell -p nix-prefetch-github --run 'nix-prefetch-github WikidPad WikidPad --rev WikidPad-2-3-beta13_01 > wikidpad_2_3.json' 
  src = fetchGitHubJSON ./wikidpad_2_3.json;
  rev = src.rev;

  python = (python27.withPackages (p: with p; [ wxPython ]));
in
  stdenv.mkDerivation {
    name = "wikidpad-${rev}";
    version = rev;

    buildInputs = [ makeWrapper ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p "$out/bin"
      makeWrapper '${python}/bin/python' "$out/bin/wikidpad" \
        --run 'cd ${src}' \
        --run 'unset GDK_PIXBUF_MODULE_FILE' `#temporary workaround for #54278` \
        --add-flags '${src}/WikidPad.py'
      '';

    meta = {
      description = ''
        wikidPad is a Wiki-like notebook for storing your thoughts, ideas,
        todo lists, contacts, or anything else you can think of to write down.
        '';
      homepage = "http://wikidpad.sourceforge.net/";
      license = with lib.licenses; [ bsd2 asl20 ];
      };
    }
