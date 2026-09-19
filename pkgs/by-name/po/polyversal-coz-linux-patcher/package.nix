{
  bash,
  coreutils,
  curl,
  fetchFromGitHub,
  flatpak,
  gawk,
  gnugrep,
  gnused,
  goss,
  lib,
  ncurses,
  pciutils,
  resholve,
  util-linux,
  zenity,
}:

resholve.mkDerivation rec {
  pname = "polyversal-coz-linux-patcher";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "CommitteeOfZero";
    repo = "polyversal-coz-linux-patcher";
    rev = version;
    hash = "sha256-wdRGnA57VXmySEFJ7Sgt7iYsxso3psh7yeJC+Ru2qF4=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D polyversal $out/bin/polyversal
  '';

  solutions = {
    default = {
      scripts = [ "bin/polyversal" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        curl
        flatpak
        gawk
        gnugrep
        gnused
        ncurses
        pciutils
        util-linux
        zenity
      ];
      keep = {
        "$all_good" = true;
        "$copies_fine" = true;
        "$has_gone_wrong" = true;
        "$has_steamgrid" = true;
        "$has_users" = true;
        "$is_deck" = true;
        "$is_flatpak" = true;
        "$is_gui" = true;
        "$just_installed" = true;
        "$opt_allow_root" = true;
        "$opt_debug" = true;
        "$opt_filelog" = true;
        "$opt_force_flatpak" = true;
        "$prev_installed" = true;
        "$ptx_cmd" = true;
        "$ptx_winecmd" = true;
        "$tar_cmd" = true;
      };
      execer = [
        "cannot:${flatpak}/bin/flatpak"
        "cannot:${zenity}/bin/zenity"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/CommitteeOfZero/polyversal-coz-linux-patcher";
    changelog = "https://github.com/CommitteeOfZero/polyversal-coz-linux-patcher/releases/tag/${version}";
    description = "Automate the process of installing CoZ Steam patches";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bbigras
    ];
    mainProgram = "polyversal";
  };
}
