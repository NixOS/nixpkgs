"""Generic FC utilities."""

from setuptools import setup
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()


setup(
    name='fc.util',
    version='1.0',
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
    packages=['fc.util'],
    install_requires=[],
)
