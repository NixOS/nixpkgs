{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, runtimeShell
, bcftools
, htslib
}:

let
  ssshtest = fetchFromGitHub {
    owner = "ryanlayer";
    repo = "ssshtest";
    rev = "d21f7f928a167fca6e2eb31616673444d15e6fd0";
    hash = "sha256-zecZHEnfhDtT44VMbHLHOhRtNsIMWeaBASupVXtmrks=";
  };
in python3Packages.buildPythonApplication rec {
  pname = "truvari";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "ACEnglish";
    repo = "truvari";
    rev = "v${version}";
    hash = "sha256-UJNMKEV5m2jFqnWvkVAtymkcE2TjPIXp7JqRZpMSqsE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-anno-trf-on-darwin.patch";
      url = "https://github.com/ACEnglish/truvari/commit/f9f36305e8eaa88f951562210e3672a4d4f71265.patch";
      hash = "sha256-7O9jTQDCC2b8hUBm0qJQCYMzTC9NFtn/E0dTHSfJALU=";
    })
    (fetchpatch {
      name = "fix-anno-grm-on-darwin.patch";
      url = "https://github.com/ACEnglish/truvari/commit/31416552008a506204ed4e2add55474f10392357.patch";
      hash = "sha256-42u0ewZU38GCoSfff+XQFv9hEFeO3WlJufTHcl6vkN4=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "rich==" "rich>="
    substituteInPlace truvari/utils.py \
      --replace "/bin/bash" "${runtimeShell}"
    patchShebangs repo_utils/test_files
  '';

  propagatedBuildInputs = with python3Packages; [
    rich
    edlib
    pysam
    intervaltree
    joblib
    numpy
    pytabix
    bwapy
    pandas
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ bcftools htslib ])
  ];

  pythonImportsCheck = [ "truvari" ];

  nativeCheckInputs = [
    bcftools
    htslib
  ] ++ (with python3Packages; [
    coverage
  ]);

  checkPhase = ''
    runHook preCheck

    ln -s ${ssshtest}/ssshtest .
    bash repo_utils/truvari_ssshtests.sh

    runHook postCheck
  '';

  meta = with lib; {
    description = "Structural variant comparison tool for VCFs";
    homepage = "https://github.com/ACEnglish/truvari";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium scalavision ];
    longDescription = ''
      Truvari is a benchmarking tool for comparison sets of SVs.
      It can calculate the recall, precision, and f-measure of a
      vcf from a given structural variant caller. The tool
      is created by Spiral Genetics.
    '';
  };
}
