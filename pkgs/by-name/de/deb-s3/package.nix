{ lib, bundlerApp }:

bundlerApp {
  pname = "deb-s3";
  exes = [ "deb-s3" ];
  gemdir = ./.;

  meta = with lib; {
    description = "A simple utility to make creating and managing APT repositories on S3";
    longDescription = ''
      Most existing guides on using S3 to host an APT repository have you using
      something like reprepro to generate the repository file structure, and
      then s3cmd to sync the files to S3.

      The annoying thing about this process is it requires you to maintain a
      local copy of the file tree for regenerating and syncing the next time.
      Personally, my process is to use one-off virtual machines with Vagrant,
      script out the build process, and then would prefer to just upload the
      final .deb from my Mac.

      With deb-s3, there is no need for this. deb-s3 features:

      - Downloads the existing package manifest and parses it.
      - Updates it with the new package, replacing the existing entry if already
        there or adding a new one if not.
      - Uploads the package itself, the Packages manifest, and the Packages.gz
        manifest. It will skip the uploading if the package is already there.
      - Updates the Release file with the new hashes and file sizes.
    '';
    homepage = "https://github.com/deb-s3/deb-s3";
    license = licenses.mit;
    maintainers = with maintainers; [ hmac ];
    platforms = platforms.unix;
    mainProgram = "deb-s3";
  };
}
