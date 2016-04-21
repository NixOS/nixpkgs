"""Maintenance request management.
"""

from setuptools import setup, find_packages
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='fc.maintenance',
    version='0.1',
    description=__doc__,
    long_description=long_description,
    url='https://github.com/flyingcircus/nixpkgs',
    author='Christian Kauhaus',
    author_email='kc@flyingcircus.io',
    license='ZPL',
    classifiers=[
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
    ],
    packages=find_packages('fc'),
    install_requires=['pytz', 'shortuuid', 'iso8601', 'PyYAML'],
    extras_require={
        'test': ['pytest', 'pytest-cov', 'pytest-capturelog', 'freezegun'],
    },
    entry_points={
        'console_scripts': [
            'fc-maintenance=fc.maintenance.reqmanager:main',
        ],
    },
)
