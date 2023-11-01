{ picom, lib, fetchFromGitHub, installShellFiles }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-allusive";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "picom-allusive";
    rev = version;
    hash = "sha256-SeL6wJNYF/v6ddDGTZ1xlUNRZA//YVrQQ21HVkSaJDI=";
  };

  nativeBuildInputs = [ installShellFiles ] ++ oldAttrs.nativeBuildInputs;

  postInstall = ''
    chmod +x $out/bin/picom-trans
    installManPage $src/man/picom.1.gz
  '' + (lib.optionalString (oldAttrs ? postInstall) oldAttrs.postInstall);

  meta = (builtins.removeAttrs oldAttrs.meta [ "longDescription" ]) // {
    description = "The only Picom fork you will ever need. With Animations and More";
    homepage = "https://github.com/allusive-dev/picom-allusive";
    license = with lib.licenses; [ mit mpl20 ];
    maintainers = with lib.maintainers; [ allusive ];
  };
})
