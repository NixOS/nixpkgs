{ lib, stdenv, fetchFromGitHub, weechat }:

stdenv.mkDerivation rec {
  pname = "edit-weechat";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "keith";
    repo = "edit-weechat";
    rev = version;
    sha256 = "1s42r0l0xkhlp6rbc23cm4vlda91il6cg53w33hqfhd2wz91s66w";
  };

  dontBuild = true;

  passthru.scripts = [ "edit.py" ];

  installPhase = ''
    runHook preInstall
    install -D edit.py $out/share/edit.py
    runHook postInstall
  '';

  meta = with lib; {
    inherit (weechat.meta) platforms;
    description = "This simple weechat plugin allows you to compose messages in your $EDITOR";
    license = licenses.mit;
    maintainers = with maintainers; [ eraserhd ];
  };
}
