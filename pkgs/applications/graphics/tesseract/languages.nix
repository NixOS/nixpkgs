{ stdenv, lib, fetchurl, fetchFromGitHub }:

rec {
  makeLanguages = { tessdataRev, tessdata ? null, all ? null, languages ? {} }:
    let
      tessdataSrc = fetchFromGitHub {
        owner = "tesseract-ocr";
        repo = "tessdata";
        rev = tessdataRev;
        sha256 = tessdata;
      };

      languageFile = lang: sha256: fetchurl {
        url = "https://github.com/tesseract-ocr/tessdata/raw/${tessdataRev}/${lang}.traineddata";
        inherit sha256;
      };
    in
      {
        all = stdenv.mkDerivation {
          name = "all";
          buildCommand = ''
            mkdir $out
            cd ${tessdataSrc}
            cp *.traineddata $out
          '';
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = all;
        };
      };

  v3 = makeLanguages {
    tessdataRev = "3cf1e2df1fe1d1da29295c9ef0983796c7958b7d";
    tessdata = "1v4b63v5nzcxr2y3635r19l7lj5smjmc9vfk0wmxlryxncb4vpg7";
    all = "0yj6h9n6h0kzzcqsn3z87vsi8pa60szp0yiayb0znd0v9my0dqhn";
  };

  v4 = makeLanguages {
    tessdataRev = "4.0.0";
    tessdata = "1chw1ya5zf8aaj2ixr9x013x7vwwwjjmx6f2ag0d6i14lypygy28";
    all = "0dqgkp369rcvq72yhgnzj1pj8yrv7kqzc7y6sqs7nzcq7l5qazlg";
  };
}
