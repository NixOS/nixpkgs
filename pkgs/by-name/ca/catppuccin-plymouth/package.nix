{ stdenvNoCC
, lib
, fetchFromGitHub
, unstableGitUpdater
, variant ? "macchiato"
}:

let
  pname = "catppuccin-plymouth";
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];
in
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "0-unstable-2024-05-28";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "e13c348a0f47772303b2da1e9396027d8cda160d";
    hash = "sha256-6DliqhRncvdPuKzL9LJec3PJWmK/jo9BrrML7g6YcH0=";
  };

  sourceRoot = "${src.name}/themes/catppuccin-${variant}";

  installPhase = ''
    runHook preInstall

    sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' catppuccin-${variant}.plymouth
    mkdir -p $out/share/plymouth/themes/catppuccin-${variant}
    cp * $out/share/plymouth/themes/catppuccin-${variant}

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Soothing pastel theme for Plymouth";
    homepage = "https://github.com/catppuccin/plymouth";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      johnrtitor
      spectre256
    ];
  };
}
