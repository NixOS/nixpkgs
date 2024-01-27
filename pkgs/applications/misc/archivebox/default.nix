{ lib
, stdenv
, python3
, fetchFromGitHub
, fetchPypi
, curl
, wget
, git
, ripgrep
, postlight-parser
, readability-extractor
, chromium
, yt-dlp
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_3.overridePythonAttrs (old: rec {
        version = "3.1.14";
        src = old.src.override {
          inherit version;
          hash = "sha256-cqSloTaiFMOc8BbM3Wtp4qoIx0ecZtk/OpteS7nYo0c=";
        };
        meta = old.meta // {
          knownVulnerabilities = [
            "CVE-2021-45115"
            "CVE-2021-45116"
            "CVE-2021-45452"
            "CVE-2022-23833"
            "CVE-2022-22818"
            "CVE-2022-28347"
            "CVE-2022-28346"
          ];
        };
      });
      django-extensions = super.django-extensions.overridePythonAttrs (old: rec {
        version = "3.1.5";
        src = fetchFromGitHub {
          inherit version;
          owner = "django-extensions";
          repo = "django-extensions";
          rev = "e43f383dae3a35237e42f6acfe1207a8e7e7bdf5";
          hash = "sha256-NAMa78KhAuoJfp0Cb0Codz84sRfRQ1JhSLNYRI4GBPM=";
        };
        # possibly a real issue, but that version is not supported anymore
        disabledTests = [ "test_should_highlight_bash_syntax_without_name" ];
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "archivebox";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hdBUEX2tOWN2b11w6aG3x7MP7KQTj4Rwc2w8XvABGf4=";
  };

  nativeBuildInputs = with python.pkgs; [
    pdm-backend
  ];

  propagatedBuildInputs = with python.pkgs; [
    croniter
    dateparser
    django
    django-extensions
    ipython
    mypy-extensions
    python-crontab
    requests
    w3lib
    yt-dlp
  ];

  makeWrapperArgs = [
    "--set USE_NODE True" # used through dependencies, not needed explicitly
    "--set READABILITY_BINARY ${lib.meta.getExe readability-extractor}"
    "--set MERCURY_BINARY ${lib.meta.getExe postlight-parser}"
    "--set CURL_BINARY ${lib.meta.getExe curl}"
    "--set RIPGREP_BINARY ${lib.meta.getExe ripgrep}"
    "--set WGET_BINARY ${lib.meta.getExe wget}"
    "--set GIT_BINARY ${lib.meta.getExe git}"
    "--set YOUTUBEDL_BINARY ${lib.meta.getExe yt-dlp}"
  ] ++ (if (lib.meta.availableOn stdenv.hostPlatform chromium) then [
    "--set CHROME_BINARY ${chromium}/bin/chromium-browser"
  ] else [
    "--set-default USE_CHROME False"
  ]);

  meta = with lib; {
    description = "Open source self-hosted web archiving";
    homepage = "https://archivebox.io";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben viraptor ];
    platforms = platforms.unix;
  };
}
