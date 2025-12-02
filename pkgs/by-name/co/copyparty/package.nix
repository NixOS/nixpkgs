# partially sourced from https://github.com/9001/copyparty/blob/hovudstraum/contrib/package/nix/copyparty/default.nix
{
  lib,

  fetchurl,

  python3Packages,

  # non-python deps
  cfssl,
  ffmpeg,
  util-linux,

  # options
  # use argon2id-hashed passwords in config files (sha2 is always available)
  withHashedPasswords ? true,

  # generate TLS certificates on startup (pointless when reverse-proxied)
  withCertgen ? true,

  # create thumbnails with Pillow; faster than FFmpeg / MediaProcessing
  withThumbnails ? true,

  # create thumbnails with PyVIPS; even faster, uses more memory
  # -- can be combined with Pillow to support more filetypes
  withFastThumbnails ? false,

  # enable FFmpeg; thumbnails for most filetypes (also video and audio), extract audio metadata, transcode audio to opus
  # -- possibly dangerous if you allow anonymous uploads, since FFmpeg has a huge attack surface
  # -- can be combined with Thumbnails and/or FastThumbnails, since FFmpeg is slower than both
  withMediaProcessing ? true,

  # if MediaProcessing is not enabled, you probably want this instead (less accurate, but much safer and faster)
  withBasicAudioMetadata ? false,

  # send ZeroMQ messages from event-hooks
  withZeroMQ ? true,

  # enable FTP server
  withFTP ? true,

  # enable FTPS support in the FTP server
  withFTPS ? false,

  # enable TFTP server
  withTFTP ? false,

  # samba/cifs server; dangerous and buggy, enable if you really need it
  withSMB ? false,

  # enables filetype detection for nameless uploads
  withMagic ? false,

  # extra packages to add to the PATH
  extraPackages ? [ ],

  # function that accepts a python packageset and returns a list of packages to
  # be added to the python venv. useful for scripts and such that require
  # additional dependencies
  extraPythonPackages ? (_p: [ ]),

  nameSuffix ? "",

  # this goes directly into meta.longDescription
  longDescription ? "Default build",
}:

let
  runtimeDeps = ([ util-linux ] ++ extraPackages ++ lib.optional withMediaProcessing ffmpeg);
in

python3Packages.buildPythonApplication rec {
  pname = "copyparty${nameSuffix}";
  version = "1.19.20";

  src = fetchurl {
    url = "https://github.com/9001/copyparty/releases/download/v${version}/copyparty-${version}.tar.gz";
    hash = "sha256-BQzMNFVOWSEKynpn2HoYbmmz9NvgE9XuLxGiLCWagqY=";
  };

  pyproject = true;

  build-system = [
    python3Packages.setuptools
  ];

  dependencies =
    with python3Packages;
    [
      jinja2
      fusepy
    ]
    ++ lib.optional withSMB impacket
    ++ lib.optional withFTP pyftpdlib
    ++ lib.optional withFTPS pyopenssl
    ++ lib.optional withTFTP partftpy
    ++ lib.optional withCertgen cfssl
    ++ (lib.optionals withThumbnails [
      pillow
      pillow-jpls
      pillow-heif
      rawpy
    ])
    ++ lib.optional withFastThumbnails pyvips
    ++ lib.optional withMediaProcessing ffmpeg
    ++ lib.optional withBasicAudioMetadata mutagen
    ++ lib.optional withHashedPasswords argon2-cffi
    ++ lib.optional withZeroMQ pyzmq
    ++ lib.optional withMagic magic
    ++ (extraPythonPackages python3Packages);

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath runtimeDeps}" ];

  meta = {
    description = "turn almost any device into a file server over http(s), webdav, ftp(s), and tftp";
    inherit longDescription;
    homepage = "https://github.com/9001/copyparty";
    license =
      let
        # list from https://github.com/9001/copyparty/blob/hovudstraum/scripts/deps-docker/Dockerfile
        includedLibraryLicenses = with lib.licenses; {
          # https://github.com/openpgpjs/asmcrypto.js
          asmcrypto = mit;
          # https://github.com/markedjs/marked
          marked = [
            # https://github.com/markedjs/marked/blob/master/LICENSE.md
            mit
            bsd3
          ];
          # https://github.com/Ionaru/easy-markdown-editor
          easy-markdown-editor = lib.licenses.mit;
          # https://github.com/codemirror/codemirror5
          codemirror = lib.licenses.mit;
          # https://github.com/cure53/DOMPurify
          dompurify = [
            asl20 # or
            mpl20
          ];
          # https://github.com/FortAwesome/Font-Awesome
          font-awesome = [
            cc-by-40
            ofl
            mit
          ];
          # https://github.com/PrismJS/prism/blob/v2/LICENSE
          prism = mit;
          # https://files.pythonhosted.org/packages/04/0b/4506cb2e831cea4b0214d3625430e921faaa05a7fb520458c75a2dbd2152/fusepy-3.0.1.tar.gz
          # https://pypi.org/project/fusepy
          # https://github.com/fusepy/fusepy
          fusepy = isc;
        };
        copypartyLicense = lib.licenses.mit;
        res = lib.pipe includedLibraryLicenses [
          builtins.attrValues
          (a: a ++ [ copypartyLicense ])
          lib.flatten
          lib.unique
        ];
      in
      res;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # the javascript deps come pre-built
      # see https://github.com/9001/copyparty/blob/hovudstraum/scripts/deps-docker/Dockerfile
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [
      shelvacu
    ];
    mainProgram = "copyparty";
    platforms = lib.platforms.all;
  };
}
