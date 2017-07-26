#!/usr/bin/env nix-shell
#!nix-shell -i python -p pythonFull pythonPackages.requests pythonPackages.pyquery pythonPackages.click

# To use, just execute this script with --help to display help.

import subprocess
import json
import sys

import click
import requests
from pyquery import PyQuery as pq


maintainers_json = subprocess.check_output([
    'nix-instantiate',
    'lib/maintainers.nix',
    '--eval',
    '--json'])
maintainers = json.loads(maintainers_json)
MAINTAINERS = {v: k for k, v in maintainers.iteritems()}


def get_response_text(url):
    return pq(requests.get(url).text)  # IO

EVAL_FILE = {
    'nixos': 'nixos/release.nix',
    'nixpkgs': 'pkgs/top-level/release.nix',
}


def get_maintainers(attr_name):
    nixname = attr_name.split('.')
    meta_json = subprocess.check_output([
        'nix-instantiate',
        '--eval',
        '--strict',
        '-A',
        '.'.join(nixname[1:]) + '.meta',
        EVAL_FILE[nixname[0]],
        '--json'])
    meta = json.loads(meta_json)
    if meta.get('maintainers'):
        return [MAINTAINERS[name] for name in meta['maintainers'] if MAINTAINERS.get(name)]


@click.command()
@click.option(
    '--jobset',
    default="nixos/release-17.03",
    help='Hydra project like nixos/release-17.03')
def cli(jobset):
    """
    Given a Hydra project, inspect latest evaluation
    and print a summary of failed builds
    """

    url = "http://hydra.nixos.org/jobset/{}".format(jobset)

    # get the last evaluation
    click.echo(click.style(
        'Getting latest evaluation for {}'.format(url), fg='green'))
    d = get_response_text(url)
    evaluations = d('#tabs-evaluations').find('a[class="row-link"]')
    latest_eval_url = evaluations[0].get('href')

    # parse last evaluation page
    click.echo(click.style(
        'Parsing evaluation {}'.format(latest_eval_url), fg='green'))
    d = get_response_text(latest_eval_url + '?full=1')

    # TODO: aborted evaluations
    # TODO: dependency failed without propagated builds
    for tr in d('img[alt="Failed"]').parents('tr'):
        a = pq(tr)('a')[1]
        print("- [ ] [{}]({})".format(a.text, a.get('href')))

        sys.stdout.flush()

        maintainers = get_maintainers(a.text)
        if maintainers:
            print("  - maintainers: {}".format(", ".join(map(lambda u: '@' + u, maintainers))))
        # TODO: print last three persons that touched this file
        # TODO: pinpoint the diff that broke this build, or maybe it's transient or maybe it never worked?

        sys.stdout.flush()


if __name__ == "__main__":
    try:
        cli()
    except:
        import pdb;pdb.post_mortem()
