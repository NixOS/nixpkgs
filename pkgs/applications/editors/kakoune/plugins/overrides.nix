{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchgit,
  buildKakounePluginFrom2Nix,
  kakoune-lsp,
  parinfer-rust,
  rep,
  fzf,
  git,
  guile,
  kakoune-unwrapped,
  lua5_3,
  plan9port,
  rustPlatform,
}:

self: super: {
  inherit kakoune-lsp parinfer-rust rep;

  case-kak = buildKakounePluginFrom2Nix {
    pname = "case-kak";
    version = "2020-04-06";
    src = fetchFromGitLab {
      owner = "FlyingWombat";
      repo = "case.kak";
      rev = "6f1511820aa3abfa118e0f856118adc8113e2185";
      sha256 = "002njrlwgakqgp74wivbppr9qyn57dn4n5bxkr6k6nglk9qndwdp";
    };
    meta.homepage = "https://gitlab.com/FlyingWombat/case.kak";
  };

  fzf-kak = super.fzf-kak.overrideAttrs (oldAttrs: {
    preFixup = ''
      if [[ -x "${fzf}/bin/fzf" ]]; then
        fzfImpl='${fzf}/bin/fzf'
      else
        fzfImpl='${fzf}/bin/sk'
      fi

      substituteInPlace $out/share/kak/autoload/plugins/fzf-kak/rc/fzf.kak \
        --replace \'fzf\' \'"$fzfImpl"\'
    '';
  });

  kak-ansi = stdenv.mkDerivation rec {
    pname = "kak-ansi";
    version = "0.2.4";

    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "kak-ansi";
      rev = "v${version}";
      sha256 = "kFjTYFy0KF5WWEHU4hHFAnD/03/d3ptjqMMbTSaGImE=";
    };

    installPhase = ''
            mkdir -p $out/bin $out/share/kak/autoload/plugins/
            cp kak-ansi-filter $out/bin/
            # Hard-code path of filter and don't try to build when Kakoune boots
            sed '
              /^declare-option.* ansi_filter /i\
      declare-option -hidden str ansi_filter %{'"$out"'/bin/kak-ansi-filter}
              /^declare-option.* ansi_filter /,/^}/d
            ' rc/ansi.kak >$out/share/kak/autoload/plugins/ansi.kak
    '';

    meta = {
      description = "Kakoune support for rendering ANSI code";
      homepage = "https://github.com/eraserhd/kak-ansi";
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [
        eraserhd
        philiptaron
      ];
      platforms = lib.platforms.all;
    };
  };

  kak-plumb = stdenv.mkDerivation rec {
    pname = "kak-plumb";
    version = "0.1.1";

    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "kak-plumb";
      rev = "v${version}";
      sha256 = "1rz6pr786slnf1a78m3sj09axr4d2lb5rg7sfa4mfg1zcjh06ps6";
    };

    installPhase = ''
      mkdir -p $out/bin $out/share/kak/autoload/plugins/
      substitute rc/plumb.kak $out/share/kak/autoload/plugins/plumb.kak \
        --replace '9 plumb' '${plan9port}/bin/9 plumb'
      substitute edit-client $out/bin/edit-client \
        --replace '9 9p' '${plan9port}/bin/9 9p' \
        --replace 'kak -p' '${kakoune-unwrapped}/bin/kak -p'
      chmod +x $out/bin/edit-client
    '';

    meta = {
      description = "Kakoune integration with the Plan 9 plumber";
      homepage = "https://github.com/eraserhd/kak-plumb";
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [
        eraserhd
        philiptaron
      ];
      platforms = lib.platforms.all;
    };
  };

  kakoune-rainbow = super.kakoune-rainbow.overrideAttrs (oldAttrs: {
    preFixup = ''
      mkdir -p $out/bin
      mv $out/share/kak/autoload/plugins/kakoune-rainbow/bin/kak-rainbow.scm $out/bin
      substituteInPlace $out/bin/kak-rainbow.scm \
        --replace '/usr/bin/env -S guile' '${guile}/bin/guile'
      substituteInPlace $out/share/kak/autoload/plugins/kakoune-rainbow/rainbow.kak \
        --replace '%sh{dirname "$kak_source"}' "'$out'"
    '';
  });

  kakoune-state-save = buildKakounePluginFrom2Nix {
    pname = "kakoune-state-save";
    version = "2020-02-09";

    src = fetchFromGitLab {
      owner = "Screwtapello";
      repo = "kakoune-state-save";
      rev = "ab7c0c765326a4a80af78857469ee8c80814c52a";
      sha256 = "AAOCG0TY3G188NnkkwMCSbkkNe487F4gwiFWwG9Yo+A=";
    };

    meta = {
      description = "Help Kakoune save and restore state between sessions";
      homepage = "https://gitlab.com/Screwtapello/kakoune-state-save";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        Flakebi
        philiptaron
      ];
      platforms = lib.platforms.all;
    };
  };

  powerline-kak = super.powerline-kak.overrideAttrs (oldAttrs: {
    preFixup = ''
      substituteInPlace $out/share/kak/autoload/plugins/powerline-kak/rc/modules/git.kak \
        --replace ' git ' ' ${git}/bin/git '
    '';
  });

  hop-kak = rustPlatform.buildRustPackage {
    pname = "hop-kak";
    version = "0.2.0";

    src = fetchgit {
      url = "https://git.sr.ht/~hadronized/hop.kak";
      rev = "7314ec64809a69e0044ba7ec57a18b43e3b5f005";
      sha256 = "stmGZQU0tp+5xxrexKMzwSwHj5F/F4HzDO9BorNWC3w=";

      # this package uses git to put the commit hash in the
      # help dialog, so leave the .git folder so the command
      # succeeds.
      leaveDotGit = true;
    };

    nativeBuildInputs = [
      git
    ];

    cargoHash = "sha256-cgUBa0rgfJFnosCgD20G1rlOl/nyXJ9bA9SSf4BuqAs=";

    postInstall = ''
      mkdir -p $out/share/kak/bin
      mv $out/bin/hop-kak $out/share/kak/bin/
    '';

    meta = {
      description = "Hinting brought to Kakoune selections";
      homepage = "https://git.sr.ht/~hadronized/hop.kak/";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ oleina ];
      platforms = lib.platforms.all;
    };
  };

  quickscope-kak = buildKakounePluginFrom2Nix rec {
    pname = "quickscope-kak";
    version = "1.0.0";

    src = fetchgit {
      url = "https://git.sr.ht/~voroskoi/quickscope.kak";
      rev = "v${version}";
      sha256 = "0y1g3zpa2ql8l9rl5i2w84bka8a09kig9nq9zdchaff5pw660mcx";
    };

    buildInputs = [ lua5_3 ];

    installPhase = ''
      mkdir -p $out/share/kak/autoload/plugins/
      cp quickscope.* $out/share/kak/autoload/plugins/
      # substituteInPlace does not like the pipe
      sed -e 's,[|] *lua,|${lua5_3}/bin/lua,' quickscope.kak >$out/share/kak/autoload/plugins/quickscope.kak
    '';

    meta = {
      description = "Highlight f and t jump positions";
      homepage = "https://sr.ht/~voroskoi/quickscope.kak/";
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [ eraserhd ];
      platforms = lib.platforms.all;
    };
  };

  kakoune-catppuccin = buildKakounePluginFrom2Nix {
    pname = "kakoune-catppuccin";
    version = "0-unstable-2024-03-29";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "kakoune";
      rev = "7f187d9da2867a7fda568b2135d29b9c00cfbb94";
      hash = "sha256-acBOQuJ8MgsMKdvFV5B2CxuxvXIYsg11n1mHEGqd120=";
    };
    meta = {
      description = "Soothing pastel theme for Kakoune";
      homepage = "https://github.com/catppuccin/kakoune/";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ philipwilk ];
    };
  };
}
