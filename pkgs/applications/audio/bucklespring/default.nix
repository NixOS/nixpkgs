{ lib
, stdenv
, fetchFromGitHub

, legacy ? false
, libinput

, pkg-config
, makeWrapper

, openal
, alure
, libXtst
, libX11
}:

let
  inherit (lib) optionals;
in
stdenv.mkDerivation rec {
  pname = "bucklespring";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = pname;
    rev = version;
    sha256 = "114dib4npb7r1z2zd1fwsx71xbf9r6psxqd7n7590cwz1w3r51mz";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ openal alure ]
    ++ optionals (legacy) [ libXtst libX11 ]
    ++ optionals (!legacy) [ libinput ];

  makeFlags = optionals (!legacy) [ "libinput=1" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wav
    cp -r $src/wav $out/share/.
    install -D ./buckle.desktop $out/share/applications/buckle.desktop
    install -D ./buckle $out/bin/buckle
    wrapProgram $out/bin/buckle --add-flags "-p $out/share/wav"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Nostalgia bucklespring keyboard sound";
    longDescription = ''
      When built with libinput (wayland or bare console),
      users need to be in the input group to use this:
      <code>users.users.alice.extraGroups = [ "input" ];</code>
    '';
    homepage = "https://github.com/zevv/bucklespring";
    license = licenses.gpl2Only;
    platforms  = platforms.unix;
    maintainers = [ maintainers.evils ];
  };
}
