This NixOS VM test implements the network topology outlined in https://github.com/scionproto/scion/blob/27983125bccac6b84d1f96f406853aab0e460405/doc/tutorials/deploy.rst#sample-scion-demo-topology, below is an excerpt from that document

Sample SCION Demo Topology
..........................

The topology of the ISD includes the inter-AS connections to neighboring ASes, and defines the underlay IP/UDP addresses of services and routers running in this AS. This is specified in topology files - this guide later explains how to configure these files. A following graphic depicts the topology on a high level.

.. figure:: https://github.com/scionproto/scion/raw/27983125bccac6b84d1f96f406853aab0e460405/doc/tutorials/deploy/SCION-deployment-guide.drawio.png
   :width: 95 %
   :figwidth: 100 %

   *Figure 1 - Topology of the sample SCION demo environment. It consists of 1 ISD, 3 core ASes and 2 non-core ASes.*
