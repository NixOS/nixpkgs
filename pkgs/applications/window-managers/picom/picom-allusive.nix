{ picom, lib, fetchFromGitHub, installShellFiles, pcre }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-allusive";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "picom-allusive";
    rev = version;
    hash = "sha256-yM4TJjoVs+i33m/u/oWlx1TDKJrgwlfiGu72DOL/tl8=";
  };

  nativeBuildInputs = [ installShellFiles pcre ] ++ oldAttrs.nativeBuildInputs;

  postInstall = ''
    installManPage $src/man/picom.1.gz
  '' + (lib.optionalString (oldAttrs ? postInstall) oldAttrs.postInstall);

  meta = (builtins.removeAttrs oldAttrs.meta [ "longDescription" ]) // {
    description = "A fork of picom featuring improved animations and other features";
    homepage = "https://github.com/allusive-dev/picom-allusive";
    license = with lib.licenses; [ mit mpl20 ];
    maintainers = with lib.maintainers; [ allusive iogamaster ];
  };
})
