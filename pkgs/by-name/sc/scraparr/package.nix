{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "scraparr";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thecfu";
    repo = "scraparr";
    tag = "v${version}";
    hash = "sha256-hU1/0zv4dJ8kHo5MdaJqFF04lpnjQbfxvWQ4IaodIzo=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; ([
    prometheus-client
    requests
    werkzeug
    python-dateutil
    pyyaml
    python-dotenv
  ]);

  pythonImportsCheck = [ "scraparr" ];

  postPatch = ''
    substituteInPlace src/scraparr/scraparr.py \
      --replace-fail 'CONFIG_FILE_LOCATION = "/scraparr/config/config.yaml"' 'CONFIG_FILE_LOCATION = "/etc/scraparr/config.yaml"'
  '';

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/${pname}

    cp -r ./src/scraparr $out/lib/${pname}/

    cat > $out/bin/scraparr << EOF
    #!${python3.interpreter}
    import sys
    sys.path.insert(0, "$out/lib/${pname}")
    import scraparr.scraparr
    EOF

    chmod +x $out/bin/scraparr

    wrapProgram $out/bin/scraparr \
      --prefix PATH : "${lib.makeBinPath dependencies}" \
      --prefix PYTHONPATH : "$out/${python3.sitePackages}"
  '';

  meta = {
    description = "Scraper for Arr applications (Sonarr, Radarr, Lidarr, Prowlarr)";
    longDescription = ''
      Scraparr is a Python application designed to scrape and collect data
      from popular Arr applications such as Sonarr, Radarr, Lidarr, and Prowlarr.
      It can be used to gather metrics and information about your media libraries
      and download activities.
    '';
    homepage = "https://github.com/thecfu/scraparr";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "scraparr";
  };
}
