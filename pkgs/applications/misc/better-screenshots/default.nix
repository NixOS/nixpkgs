{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grim,
  slurp,
  wl-clipboard,
  makeWrapper,
  click,
  pillow,
  toml,
  pyyaml,
  requests,
  setuptools,
}:

buildPythonPackage {
  pname = "better-screenshots";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "snxhasish";
    repo = "better-screenshots";
    rev = "2f834716edd4a80504bacdbd3ddc24c1d63a20af";
    hash = "sha256-8iydpppaonyj+pJDdjG7tFG9hKLNjey/DZenQAyubMk=";
  };

  format = "pyproject";

  buildInputs = [
    setuptools
  ];

  dependencies = [
    click
    pillow
    toml
    pyyaml
    requests
  ];

  postInstall = ''
    wrapProgram $out/bin/better-screenshots \
      --prefix PATH : "${
        lib.makeBinPath [
          grim
          slurp
          wl-clipboard
        ]
      }"
  '';

  meta = with lib; {
    description = "CLI screenshot tool for Linux with background customization";
    homepage = "https://github.com/snxhasish/better-screenshots";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
