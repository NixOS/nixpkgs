{ lib
, stdenv
, fetchFromGitHub
, metasploit
}:

stdenv.mkDerivation rec {
  pname = "msfpc";
  version = "unstable-2021-01-07";

  src = fetchFromGitHub {
    owner = "g0tmi1k";
    repo = "msfpc";
    rev = "8007ef2142e43dc5e97edf84f40ac012f94a3e8f";
    hash = "sha256-/FNhQcjIEIzB+wRKF2e3eYEnuVrl0egBZvjZidCwvHg=";
  };

  postPatch = ''
    patchShebangs msfpc.sh
  '';

  buildInputs = [ metasploit ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    chmod +x msfpc.sh
    cp msfpc.sh $out/bin/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/g0tmi1k/msfpc";
    description = "A wrapper to generate multiple types of payloads";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    mainProgram = "msfpc";
  };
}
