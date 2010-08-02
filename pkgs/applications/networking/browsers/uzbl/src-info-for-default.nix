{
  baseName = "uzbl-stable";
  downloadPage = "http://github.com/Dieterbe/uzbl/downloads";
  sourceRegexp = "/tarball/";
  versionExtractorSedScript = ''s@.*[/]@@'';
  versionReferenceCreator = ''$(replaceAllVersionOccurences)'';
  extraVars = "downloadName";
  eval_downloadName = ''downloadName=$version.tar.gz'';
}
