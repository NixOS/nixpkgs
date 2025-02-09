{ lib, fetchFromGitHub, buildLua, mpv-unwrapped }:

buildLua {
  pname = "mpv-thumbfast";
  version = "unstable-2023-12-08";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "03e93feee5a85bf7c65db953ada41b4826e9f905";
    hash = "sha256-5u5WBvWOEydJrnr/vilEgW4+fxkxM6wNjb9Fyyxx/1c=";
  };

  passthru.extraWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.getBin mpv-unwrapped}/bin"
  ];

  meta = {
    description = "High-performance on-the-fly thumbnailer for mpv";
    homepage = "https://github.com/po5/thumbfast";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
