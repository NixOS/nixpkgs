{
  testers,
  fetchNextcloudApp,
  ...
}:

{
  simple-sha512 = testers.invalidateFetcherByDrvHash fetchNextcloudApp {
    appName = "phonetrack";
    appVersion = "0.8.2";
    license = "agpl3Plus";
    sha512 = "f67902d1b48def9a244383a39d7bec95bb4215054963a9751f99dae9bd2f2740c02d2ef97b3b76d69a36fa95f8a9374dd049440b195f4dad2f0c4bca645de228";
    url = "https://github.com/julien-nc/phonetrack/releases/download/v0.8.2/phonetrack-0.8.2.tar.gz";
  };
  simple-sha256 = testers.invalidateFetcherByDrvHash fetchNextcloudApp {
    appName = "phonetrack";
    appVersion = "0.8.2";
    license = "agpl3Plus";
    sha256 = "7c4252186e0ff8e0b97fc3d30131eeadd51bd2f9cc6aa321eb0c1c541f9572c0";
    url = "https://github.com/julien-nc/phonetrack/releases/download/v0.8.2/phonetrack-0.8.2.tar.gz";
  };
}
