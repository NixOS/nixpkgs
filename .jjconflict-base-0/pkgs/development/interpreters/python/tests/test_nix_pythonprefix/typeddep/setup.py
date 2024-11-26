from setuptools import setup

setup(**{
    'name': 'typeddep',
    'version': '1.3.3.7',
    'description': 'Minimal repro to test mypy and site prefixes with Nix',
    'long_description': None,
    'author': 'adisbladis',
    'author_email': 'adisbladis@gmail.com',
    'maintainer': None,
    'maintainer_email': None,
    'url': None,
    'packages': ['typeddep'],
    'package_data': {'': ['*']},
    'install_requires': [],
    'entry_points': {},
    'python_requires': '>=3.7,<4.0',
})
