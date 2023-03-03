# run the tests with nixt <absolutePath to parent dir> -v

{ pkgs ? import <nixpkgs> { }, nixt }:
let
  inherit (import ./update-utils.nix { inherit (pkgs) lib; })
    extractLatestVersionFromHtml
    extractSha256FromHtml
    getLatestStableVersion;
in
nixt.mkSuite "LibreOffice Updater"
{
  "should extract latest stable version from html" =
    let
      latestVersionHtmlMock =
        ''
          <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
          <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
          <title>Index of /libreoffice/stable</title>
          <link rel="stylesheet" href="/mirrorbrain.css" type="text/css" />
          </head>
          <body>
          <h1>Index of /libreoffice/stable</h1>
          <table><tr><th>&nbsp;</th><th><a href="?C=N;O=D">Name</a></th><th><a href="?C=M;O=A">Last modified</a></th><th><a href="?C=S;O=A">Size</a></th><th>Metadata</th></tr><tr><th colspan="5"><hr /></th></tr>
          <tr><td valign="top">&nbsp;</td><td><a href="/libreoffice/">Parent Directory</a></td><td>&nbsp;</td><td align="right">  - </td><td>&nbsp;</td></tr>
          <tr><td valign="top">&nbsp;</td><td><a href="7.2.7/">7.2.7/</a></td><td align="right">10-Mar-2022 11:12  </td><td align="right">  - </td><td>&nbsp;</td></tr>
          <tr><td valign="top">&nbsp;</td><td><a href="7.3.3/">7.3.3/</a></td><td align="right">12-May-2022 10:06  </td><td align="right">  - </td><td>&nbsp;</td></tr>
          <tr><td valign="top">&nbsp;</td><td><a href="7.2.6/">7.2.6/</a></td><td align="right">05-May-2022 07:57  </td><td align="right">  - </td><td>&nbsp;</td></tr>
          <tr><th colspan="5"><hr /></th></tr>
          </table>
          <address>Apache Server at <a href="mailto:hostmaster@documentfoundation.org">download.documentfoundation.org</a> Port 80</address>
          <br/><address><a href="http://mirrorbrain.org/">MirrorBrain</a> powered by <a href="http://httpd.apache.org/">Apache</a></address>
          </body></html>
        '';

      actual = extractLatestVersionFromHtml latestVersionHtmlMock;

    in
    "7.3.3" == actual;

  "should extract latest stable version from website" = (builtins.compareVersions getLatestStableVersion "7.3.3") >= 0;

  "should extract sha256 from html" =
    let
      sha256Html = "50ed3deb8d9c987516e2687ebb865bca15486c69da79f1b6d74381e43f2ec863  LibreOffice_7.3.3_MacOS_aarch64.dmg\n";
      actual = extractSha256FromHtml sha256Html;
    in
    "50ed3deb8d9c987516e2687ebb865bca15486c69da79f1b6d74381e43f2ec863" == actual;
}
