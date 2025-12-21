{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  backgroundVariants ? [ "forest" ],
  styleVariants ? [ "window" ],
  sideVariants ? [ "left" ],
  colorVariants ? [ "dark" ],
  screenVariants ? "1080p",
  logoVariants ? "default",
}:

let
  pname = "elegant-grub2-themes";
  single = x: lib.optional (x != null) x;
in
lib.checkListOfEnum "${pname}: backgroundVariants" [ "forest" "mojave" "mountain" "wave" ]
  backgroundVariants
  lib.checkListOfEnum
  "${pname}: styleVariants"
  [ "window" "float" "sharp" "blur" ]
  styleVariants
  lib.checkListOfEnum
  "${pname}: sideVariants"
  [ "left" "right" ]
  sideVariants
  lib.checkListOfEnum
  "${pname}: colorVariants"
  [ "dark" "light" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: screenVariants"
  [ "1080p" "2k" "4k" ]
  (single screenVariants)
  lib.checkListOfEnum
  "${pname}: logoVariants"
  [ "default" "system" ]
  (single logoVariants)

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2025-09-13";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Elegant-grub2-themes";
      rev = "92cdac334cf7bc5c1d68c2fbb266164653b4b502";
      hash = "sha256-fbZLWHxnLBrqBrS2MnM2G08HgEM2dmZvitiCERie0Cc=";
    };

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done
    '';

    installPhase = ''
      runHook preInstall

        ./generate.sh --dest $out/grub/themes \
        --theme ${toString backgroundVariants} \
        --type ${toString styleVariants} \
        --side ${toString sideVariants} \
        --color ${toString colorVariants} \
        --screen ${toString screenVariants} \
        --logo ${toString logoVariants}

      runHook postInstall
    '';

    meta = with lib; {
      description = "Elegant grub2 themes for all linux systems";
      homepage = "https://github.com/vinceliuice/Elegant-grub2-themes";
      license = licenses.gpl3Only;
      maintainers = [ ];
      platforms = lib.platforms.linux;
    };
  }
