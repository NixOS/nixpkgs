# Some repositories (such as Devpi) expose the Pypi legacy API
# (https://warehouse.pypa.io/api-reference/legacy.html).
#
# Note it is not possible to use pip
# https://discuss.python.org/t/pip-download-just-the-source-packages-no-building-no-metadata-etc/4651/12

import base64
import argparse
import netrc
import os
import shutil
import ssl
import sys
import urllib.request
from html.parser import HTMLParser
from os.path import normpath
from typing import Optional
from urllib.parse import urlparse, urlunparse


# Parse the legacy index page to extract the href and package names
class Pep503(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.sources: dict[str, str] = {}
        self.url: Optional[str] = None
        self.name: Optional[str] = None

    def handle_data(self, data: str) -> None:
        if self.url is not None:
            self.name = data

    def handle_starttag(self, tag: str, attrs: list[tuple[str, Optional[str]]]) -> None:
        if tag == "a":
            for name, value in attrs:
                if name == "href":
                    self.url = value

    def handle_endtag(self, tag: str) -> None:
        if self.url is not None:
            if not self.name:
                raise ValueError("Name not set")

            self.sources[self.name] = self.url
        self.url = None


def try_fetch(url: str, package_name: str, package_filename: str) -> None:
    index_url = url + "/" + package_name + "/"

    # Parse username and password for this host from the netrc file if given.
    username: Optional[str] = None
    password: Optional[str] = None
    if os.environ.get("NETRC", "") != "":
        netrc_obj = netrc.netrc(os.environ["NETRC"])
        host = urlparse(index_url).netloc
        # Strip port number if present
        if ":" in host:
            host = host.split(":")[0]
        authenticators = netrc_obj.authenticators(host)
        if authenticators:
            username, _, password = authenticators

    print("Reading index %s" % index_url)

    context = ssl.create_default_context()

    # Extract out username/password from index_url, if present.
    parsed_url = urlparse(index_url)
    username = parsed_url.username or username
    password = parsed_url.password or password
    index_url = parsed_url._replace(netloc=parsed_url.netloc.rpartition("@")[-1]).geturl()

    req = urllib.request.Request(index_url)

    if username and password:  # Add authentication
        password_b64 = base64.b64encode(":".join((username, password)).encode()).decode("utf-8")
        req.add_header("Authorization", "Basic {}".format(password_b64))
    else:  # If we are not using authentication disable TLS verification for long term reproducibility
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE

    response = urllib.request.urlopen(req, context=context)
    index = response.read()

    parser = Pep503()
    parser.feed(str(index, "utf-8"))
    if package_filename not in parser.sources:
        print("The file %s has not be found in the index %s" % (package_filename, index_url))
        exit(1)

    package_file = open(package_filename, "wb")
    # Sometimes the href is a relative or absolute path within the index's domain.
    indicated_url = urlparse(parser.sources[package_filename])
    if indicated_url.netloc == "":
        parsed_url = urlparse(index_url)

        if indicated_url.path.startswith("/"):
            # An absolute path within the index's domain.
            path = parser.sources[package_filename]
        else:
            # A relative path.
            path = parsed_url.path + "/" + parser.sources[package_filename]

        package_url = urlunparse(
            (
                parsed_url.scheme,
                parsed_url.netloc,
                path,
                None,
                None,
                None,
            )
        )
    else:
        package_url = parser.sources[package_filename]

    # Handle urls containing "../"
    parsed_url = urlparse(package_url)
    real_package_url = urlunparse(
        (
            parsed_url.scheme,
            parsed_url.netloc,
            normpath(parsed_url.path),
            parsed_url.params,
            parsed_url.query,
            parsed_url.fragment,
        )
    )
    print("Downloading %s" % real_package_url)

    req = urllib.request.Request(real_package_url)
    if username and password:
        req.add_unredirected_header("Authorization", "Basic {}".format(password_b64))
    response = urllib.request.urlopen(req, context=context)

    with response as r:
        shutil.copyfileobj(r, package_file)


argparser = argparse.ArgumentParser(description="Fetch file from legacy pypi API")
argparser.add_argument("--url", action="append", required=True)
argparser.add_argument("--pname", action="store", required=True)
argparser.add_argument("--filename", action="store", required=True)


if __name__ == "__main__":
    args = argparser.parse_args()
    for url in args.url:
        try:
            try_fetch(url, args.pname, args.filename)
        except urllib.error.HTTPError as e:
            print("Got exception'", e, "', trying next package index", file=sys.stderr)
            continue
        else:
            break
    else:
        print(
            f"Could not fetch package '{args.pname}' file '{args.filename}' from any mirrors: {args.url}",
            file=sys.stderr,
        )
        exit(1)
