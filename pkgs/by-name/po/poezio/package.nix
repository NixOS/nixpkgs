{
  lib,
  fetchFromCodeberg,
  pkg-config,
  python3,
  sphinxHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "poezio";
  version = "0.16";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "poezio";
    repo = "poezio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bpudgf9oZ+7w7izAuWYKFVO9CIHraHaGvRKLDuSIF7c=";
  };

  nativeBuildInputs = [ pkg-config ];
  build-system = with python3.pkgs; [
    setuptools
    sphinxHook
    aiohttp
  ];

  dependencies = with python3.pkgs; [
    dependency-groups
    setuptools
    slixmpp
  ];

  optional-dependencies = {
    plugins = with python3.pkgs; [
      pyinotify
      aiohttp
      pygments
      qrcode
      pillow
      python-musicpd
    ];
  };

  preBuild = ''
    ${python3.pythonOnBuildForHost.interpreter} setup.py build_ext --inplace
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  outputs = [
    "out"
    "man"
  ];

  sphinxBuilders = [
    "man"
  ];

  pythonImportsCheck = [
    "poezio"
  ];

  meta = {
    description = "Free console XMPP client";
    longDescription = ''
      Its goal is to let you connect very easily (no account creation needed) to
      the network and join various chatrooms, immediately. It tries to look like
      the most famous IRC clients (weechat, irssi, etc). Many commands are
      identical and you won't be lost if you already know these clients.
      Configuration can be made in a configuration file or directly from
      the client.

      You'll find the light, fast, geeky and anonymous spirit of IRC while using
      a powerful, standard and open protocol.
    '';
    homepage = "https://poez.io";
    changelog = "https://codeberg.org/poezio/poezio/src/tag/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.zlib;
  };
})
