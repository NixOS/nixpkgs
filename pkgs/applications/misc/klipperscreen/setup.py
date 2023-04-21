from setuptools import setup

setup(
  name='KlipperScreen',
  install_requires=[],
  packages=['styles', 'panels', 'ks_includes', 'ks_includes.widgets'],
  package_data={'ks_includes': ['defaults.conf', 'locales/**', 'emptyCursor.xbm'], 'styles': ['**']},
  entry_points={
      'console_scripts': ['KlipperScreen=screen:main']
  },
)
