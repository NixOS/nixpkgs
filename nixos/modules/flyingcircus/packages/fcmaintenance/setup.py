"""Maintenance request management."""

from setuptools import setup
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()

test_req = ['pytest', 'pytest-cov', 'pytest-catchlog', 'freezegun']

setup(
    name='fc.maintenance',
    version='2.0',
    description=__doc__,
    long_description=long_description,
    url='https://github.com/flyingcircus/nixpkgs',
    author='Christian Kauhaus',
    author_email='kc@flyingcircus.io',
    license='ZPL',
    classifiers=[
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
    ],
    packages=['fc.maintenance', 'fc.maintenance.lib'],
    install_requires=['fc.util', 'pytz', 'shortuuid', 'iso8601', 'PyYAML'],
    extras_require={
        'test': test_req,
        'dev': test_req + ['pytest-cov'],
    },
    entry_points={
        'console_scripts': [
            'fc-maintenance=fc.maintenance.reqmanager:main',
            'list-maintenance=fc.maintenance.reqmanager:list_maintenance',
            'maintenance-script=fc.maintenance.lib.shellscript:main',
        ],
    },
)
