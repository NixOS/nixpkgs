from setuptools import setup, find_packages

setup(
  name="nixos-test-driver",
  version='1.1',
  packages=find_packages(),
  package_data={"test_driver": ["py.typed"]},
  entry_points={
    "console_scripts": [
      "nixos-test-driver=test_driver:main",
      "generate-driver-symbols=test_driver:generate_driver_symbols"
    ]
  },
)
