{ lib
, stdenv
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "stepreduce";
  version = "unstable-2020-04-30";

  src = fetchFromGitLab {
    owner = "sethhillbrand";
    repo = "stepreduce";
    rev = "e89091c33b67e2a18584e1fe3560bfd48ae98773";
    hash = "sha256-bCseBQ6J3sWFt0kzaRkV11lwzOGvNPebvQ6w4OJaMBs=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 stepreduce $out/bin/stepreduce

    runHook prostInstall
  '';

  meta = with lib; {
    description = "Reduces STEP file size by removing redundancy";
    homepage = "https://gitlab.com/sethhillbrand/stepreduce";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ evils ];
  };
}
